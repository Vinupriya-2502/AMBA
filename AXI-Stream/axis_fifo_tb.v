module axis_fifo_tb;

// Parameters
parameter DATA_WIDTH = 8;
parameter ADDR_DEPTH = 4;

// Inputs and Outputs
reg m_aclk;
reg m_areset_n;
reg [DATA_WIDTH-1:0] m_tdata;
reg m_tvalid;
wire m_tready;
reg m_tlast;

reg s_aclk;
reg s_areset_n;
wire [DATA_WIDTH-1:0] s_tdata;
wire s_tvalid;
reg s_tready;
wire s_tlast;

// Instance of the RTL code
axis_fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_DEPTH(ADDR_DEPTH)
) dut (
    
    .m_aclk(m_aclk),
    .m_areset_n(m_areset_n),
    .m_tdata(m_tdata),
    .m_tvalid(m_tvalid),
    .m_tready(m_tready),
    .m_tlast(m_tlast),
    .s_aclk(s_aclk),
    .s_areset_n(s_areset_n),
    .s_tdata(s_tdata),
    .s_tvalid(s_tvalid),
    .s_tready(s_tready),
    .s_tlast(s_tlast)
);
task write();
  begin
    m_tvalid = 1;
    m_tdata = $random;
    
    #6;
   // m_tvalid =0;
   
  end
  endtask
  
  task read();
  begin
    s_tready = 1;
    #6;
   s_tready=0;
    #6;
   s_tready = 1;
    #6;
   s_tready = 0;
    

  end
  endtask
    
always #6 s_aclk = ~s_aclk;
// Test cases
initial begin
    m_aclk = 0;
    s_aclk = 0;
    forever #5 m_aclk = ~m_aclk;
end

initial begin
    // Reset the design
    m_areset_n = 0;
    s_areset_n = 0;
 #10
    s_areset_n = 1;
    #10
  m_areset_n = 1;
  
  repeat(7) begin
      write();
    end
      m_tlast =1; 
  repeat(6) begin
        read();
      end
    // End the simulation
    $finish;
end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end

endmodule
