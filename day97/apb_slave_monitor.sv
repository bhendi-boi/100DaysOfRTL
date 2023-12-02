`include "uvm_macros.svh"

import uvm_pkg::*;

class apb_slave_monitor extends uvm_monitor;
  
  `uvm_component_utils(apb_slave_monitor);
  
  virtual apb_slave_if vif;
  uvm_analysis_port#(apb_slave_item) mon_analysis_port;
  
  function new (string name="apb_slave_monitor", uvm_component parent);
    super.new (name, parent);
  endfunction
  
  // Get the virtual interface handle in the build phase
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    mon_analysis_port = new("mon_analysis_port", this);
    if (!uvm_config_db#(virtual apb_slave_if)::get(this, "", "apb_slave_vif", vif)) begin
      `uvm_fatal("MONITOR", "Could not get a handle to the virtual interface");
    end
  endfunction
  
  // Monitor the interface in the run_phase
  virtual task run_phase (uvm_phase phase);
    apb_slave_item item = new;
    super.run_phase (phase);
    forever begin
      item.psel   	= vif.cb.psel;
      item.penable	= vif.cb.penable;
      item.paddr	= vif.cb.paddr;
      item.prdata 	= vif.cb.prdata;
      item.pwrite 	= vif.cb.pwrite;
      item.pwdata 	= vif.cb.pwdata;
      item.pready	= vif.cb.pready;
      
      item.dmem_psel   	= vif.cb.dmem_psel;
      item.dmem_penable	= vif.cb.dmem_penable;
      item.dmem_paddr	= vif.cb.dmem_paddr;
      item.dmem_prdata 	= vif.cb.dmem_prdata;
      item.dmem_pwrite 	= vif.cb.dmem_pwrite;
      item.dmem_pwdata 	= vif.cb.dmem_pwdata;
      item.dmem_pready	= vif.cb.dmem_pready;
      
      if (item.psel) begin
        `uvm_info(get_type_name(), item.tx2string(), UVM_LOW)
        //`uvm_info(get_type_name(), item.riscv_tx2string(), UVM_LOW)
      end else if (item.dmem_psel)
        `uvm_info(get_type_name(), item.mem_tx2string(), UVM_LOW)
      // Broadcast to all the subscriber class
      mon_analysis_port.write(item);
      @(vif.cb);
    end
  endtask
  
endclass