{ lib, ... }:
{
  # allow perf as user
  boot.kernel.sysctl."kernel.perf_event_paranoid" = -1;
  # allow perf users to see kernel pointers
  boot.kernel.sysctl."kernel.kptr_restrict" = lib.mkForce 0;
}
