#!/bin/bash
# Clear turbo-disable (bit 38 of IA32_MISC_ENABLE) and make intel_pstate re-read limits
for c in $(seq 0 $(( $(nproc) - 1 ))); do
  v=$(/usr/sbin/rdmsr -p $c 0x1A0)
  /usr/sbin/wrmsr -p $c 0x1A0 $(printf '0x%x' $(( 0x$v & ~(1<<38) )))
done
echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
echo passive > /sys/devices/system/cpu/intel_pstate/status
echo active > /sys/devices/system/cpu/intel_pstate/status
