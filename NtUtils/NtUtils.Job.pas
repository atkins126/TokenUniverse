unit NtUtils.Job;

interface

uses
  Winapi.WinNt, Ntapi.ntpsapi, NtUtils.Exceptions;

// Create new job object
function NtxCreateJob(out hJob: THandle; ObjectName: String = '';
  RootDirectory: THandle = 0; HandleAttributes: Cardinal = 0): TNtxStatus;

// Open job object by name
function NtxOpenJob(out hJob: THandle; DesiredAccess: TAccessMask;
  ObjectName: String; RootDirectory: THandle = 0;
  HandleAttributes: Cardinal = 0): TNtxStatus;

// Enumerate active processes in a job
function NtxEnurateProcessesInJob(hJob: THandle;
  out ProcessIds: TArray<NativeUInt>): TNtxStatus;

type
  NtxJob = class
    // Query fixed-size information
    class function Query<T>(hJob: THandle;
      InfoClass: TJobObjectInfoClass; out Buffer: T): TNtxStatus; static;

    // Set fixed-size information
    class function SetInfo<T>(hJob: THandle;
      InfoClass: TJobObjectInfoClass; const Buffer: T): TNtxStatus; static;
  end;

implementation

uses
  Ntapi.ntdef, Ntapi.ntstatus;

function NtxCreateJob(out hJob: THandle; ObjectName: String;
  RootDirectory: THandle; HandleAttributes: Cardinal): TNtxStatus;
var
  ObjAttr: TObjectAttributes;
  NameStr: UNICODE_STRING;
begin
  if ObjectName <> '' then
  begin
    NameStr.FromString(ObjectName);
    InitializeObjectAttributes(ObjAttr, @NameStr, HandleAttributes,
      RootDirectory);
  end
  else
    InitializeObjectAttributes(ObjAttr, nil, HandleAttributes);

  Result.Location := 'NtCreateJobObject';
  Result.Status := NtCreateJobObject(hJob, JOB_OBJECT_ALL_ACCESS, @ObjAttr);
end;

function NtxOpenJob(out hJob: THandle; DesiredAccess: TAccessMask;
  ObjectName: String; RootDirectory: THandle; HandleAttributes: Cardinal):
  TNtxStatus;
var
  ObjAttr: TObjectAttributes;
  NameStr: UNICODE_STRING;
begin
  NameStr.FromString(ObjectName);
  InitializeObjectAttributes(ObjAttr, @NameStr, HandleAttributes,
    RootDirectory);

  Result.Location := 'NtOpenJobObject';
  Result.LastCall.CallType := lcOpenCall;
  Result.LastCall.AccessMask := DesiredAccess;
  Result.LastCall.AccessMaskType := TAccessMaskType.objNtJob;
  Result.Status := NtOpenJobObject(hJob, DesiredAccess, ObjAttr);
end;

function NtxEnurateProcessesInJob(hJob: THandle;
  out ProcessIds: TArray<NativeUInt>): TNtxStatus;
var
  BufferSize: Cardinal;
  Buffer: PJobBasicProcessIdList;
  MaxCount: Cardinal;
  i: Integer;
begin
  Result.Location := 'NtQueryInformationJobObject';
  Result.LastCall.CallType := lcQuerySetCall;
  Result.LastCall.InfoClass := Cardinal(JobObjectBasicProcessIdList);
  Result.LastCall.InfoClassType := TypeInfo(TJobObjectInfoClass);

  MaxCount := 5; // Initial buffer capacity. Must be at least one.

  repeat
    // Allocate a buffer for MaxCount items
    BufferSize := SizeOf(Cardinal) * 2 + SizeOf(NativeUInt) * MaxCount;

    if BufferSize > BUFFER_LIMIT then
    begin
      Result.Status := STATUS_IMPLEMENTATION_LIMIT;
      Exit;
    end;

    Buffer := AllocMem(BufferSize);

    // Query PID list
    Result.Status := NtQueryInformationJobObject(hJob,
      JobObjectBasicProcessIdList, Buffer, BufferSize, nil);

    // STATUS_BUFFER_OVERFLOW means there are more entries and is fine
    if not Result.IsSuccess and (Result.Status <> STATUS_BUFFER_OVERFLOW) then
    begin
      FreeMem(Buffer);
      Exit;
    end;

    // Do we need another pass?
    if Buffer.NumberOfAssignedProcesses > MaxCount then
    begin
      FreeMem(Buffer);

      // Number of currently assigned processes + some extra capacity
      MaxCount := Buffer.NumberOfAssignedProcesses +
        Buffer.NumberOfAssignedProcesses shr 3 + 1; // Value + 12% + 1
    end
    else
      Break;

  until False;

  SetLength(ProcessIds, Buffer.NumberOfProcessIdsInList);

  for i := 0 to High(ProcessIds) do
    ProcessIds[i] := Buffer.ProcessIdList[i];

  FreeMem(Buffer);
end;

class function NtxJob.Query<T>(hJob: THandle; InfoClass: TJobObjectInfoClass;
  out Buffer: T): TNtxStatus;
begin
  Result.Location := 'NtQueryInformationJobObject';
  Result.LastCall.CallType := lcQuerySetCall;
  Result.LastCall.InfoClass := Cardinal(InfoClass);
  Result.LastCall.InfoClassType := TypeInfo(TJobObjectInfoClass);
  Result.Status := NtQueryInformationJobObject(hJob, InfoClass, @Buffer,
    SizeOf(Buffer), nil);
end;

class function NtxJob.SetInfo<T>(hJob: THandle; InfoClass: TJobObjectInfoClass;
  const Buffer: T): TNtxStatus;
begin
  Result.Location := 'NtSetInformationJobObject';
  Result.LastCall.CallType := lcQuerySetCall;
  Result.LastCall.InfoClass := Cardinal(InfoClass);
  Result.LastCall.InfoClassType := TypeInfo(TJobObjectInfoClass);
  Result.Status := NtSetInformationJobObject(hJob, InfoClass, @Buffer,
    SizeOf(Buffer));
end;

end.
