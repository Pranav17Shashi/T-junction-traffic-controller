module traffic_fsm(
    input  logic       clk,
    input  logic       reset,
    input  logic [6:0] timer,

    output logic A_red,
    output logic A_straight_green,
    output logic A_left_green,

    output logic B_red,
    output logic B_left_green,
    output logic B_right_green,

    output logic C_red,
    output logic C_straight_green,
    output logic C_right_green
);

typedef enum logic [1:0] {
    S0,
    S1,
    S2,
    S3
} statetype;

statetype state, nextstate;


// State Register

always_ff @(posedge clk or posedge reset)
begin
    if(reset)
        state <= S0;
    else
        state <= nextstate;
end


// Next State Logic

always_comb
begin
    case(state)

        S0:
            if(timer < 40)
                nextstate = S0;
            else
                nextstate = S1;

        S1:
            if(timer < 60)
                nextstate = S1;
            else
                nextstate = S2;

        S2:
            if(timer < 80)
                nextstate = S2;
            else
                nextstate = S3;

        S3:
            if(timer < 90)
                nextstate = S3;
            else
                nextstate = S0;

        default:
            nextstate = S0;

    endcase
end


// Output Logic

always_comb
begin

    // Default: all red
    A_red = 1;
    B_red = 1;
    C_red = 1;

    A_straight_green = 0;
    A_left_green     = 0;

    B_left_green     = 0;
    B_right_green    = 0;

    C_straight_green = 0;
    C_right_green    = 0;

    case(state)

        // 0-40 sec
        

        S0:
        begin
            A_red = 0;
            C_red = 0;

            A_straight_green = 1;
            C_straight_green = 1;
        end

        // 40-60 sec
        

        S1:
        begin
            A_red = 0;
            B_red = 0;

            A_left_green  = 1;
            B_right_green = 1;
        end

        // 60-80 sec
        

        S2:
        begin
            B_red = 0;
            C_red = 0;

            B_left_green = 1;
            C_right_green = 1;
        end

        // 80-90 sec
        

        S3:
        begin
            
        end

    endcase
end

endmodule