# Fixed_priority_interrupt_controller
This Verilog FPIC latches 4 IRQs to prevent missed events. A nested encoder prioritizes IRQ3 down to IRQ0. It handles CPU comms via a valid/ack handshake, clearing only the active interrupt using a shifting bitmask while keeping other pending requests alive.
