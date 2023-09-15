onerror {exit -code 1}
vlib work
vlog -work work LogicalStep_Lab3_top.vo
vlog -work work Waveform2.vwf.vt
vsim -novopt -c -t 1ps -L fiftyfivenm_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.LogicalStep_Lab3_top_vlg_vec_tst -voptargs="+acc"
vcd file -direction LogicalStep_Lab3.msim.vcd
vcd add -internal LogicalStep_Lab3_top_vlg_vec_tst/*
vcd add -internal LogicalStep_Lab3_top_vlg_vec_tst/i1/*
run -all
quit -f
