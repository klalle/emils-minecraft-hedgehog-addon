# Hindrar att Windows går i strömsparläge så länge process <ProcessId> lever.
# Ändrar inga systeminställningar: kravet släpps när den här processen avslutas.
param([Parameter(Mandatory)][int]$ProcessId)

Add-Type -Namespace Win32 -Name Power -MemberDefinition @'
[System.Runtime.InteropServices.DllImport("kernel32.dll")]
public static extern uint SetThreadExecutionState(uint esFlags);
'@
# ES_CONTINUOUS | ES_SYSTEM_REQUIRED
[void][Win32.Power]::SetThreadExecutionState(0x80000001)
Wait-Process -Id $ProcessId -ErrorAction SilentlyContinue
