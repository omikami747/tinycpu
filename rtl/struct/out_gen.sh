#!/bin/bash
iverilog tinycpu_test.v sram.v sim_env.v toplevel.v cmp.v alu.v data_path.v cpu_reg.v cpu_ctrl.v sram_ctrl.v -o struct
