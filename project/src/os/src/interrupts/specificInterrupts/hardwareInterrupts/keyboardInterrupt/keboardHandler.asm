[bits 64]

%include "src/os/src/interrupts/specificInterrupts/popAndPushAll.inc"

[extern isrKeyboardHandler]
asmIsrKeyboardHandler:
  pushaq
  call isrKeyboardHandler
  popaq

  sti
  iretq ; returning from the interrupt
  global asmIsrKeyboardHandler