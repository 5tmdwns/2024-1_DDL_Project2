<p align="center">
  <h1 align="center">실시간 교통량을 기반으로 한 교차로 신호등 Controller✨</h1>
  <p align="center">
    <img width="90%" alt="Simulation Full Screen" src="https://github.com/user-attachments/assets/4a4d7587-af02-4c5b-8604-4b835c97bd37" />
  </p>
</p>

## Index ⭐️
- [1. 프로젝트 주제 및 목표](#1-프로젝트-주제-및-목표) <br/>
- [2. 프로젝트 설계 및 구성](#2-프로젝트-설계-및-구성) <br/>
  - [2-1. Circuit Diagram](#2-1-Circuit-Diagram) <br/>
  - [2-2. System Description](#2-2-System-Description) <br/>
  - [2-3. 각 System 역할](#2-3-각-System-역할) <br/>
- [3. 각 System 설명](#3-각-system-설명) <br/>
- [4. Module Verification](#4-Module-Verification) <br/>
  - [4-1. Interface](#4-1-Interface) <br/>
  - [4-2. Randomize Testbench Input](#4-2-Randomize-Testbench-Input) <br/>
  - [4-3. Assertion(Immediate, Not Concurrent)](#4-3-AssertionImmediate-Not-Concurrent) <br/>
- [5. Testbench Waveform](#Testbench-Waveform) <br/>
- [6. 결론](#결론) <br/>

## 1. 프로젝트 주제 및 목표
&nbsp;본 프로젝트의 주제는 매 시간 마다 Main Highway 의 실시간 교통량과 Country road 에 정차되어있는 자동차 대수를 측정하여 이를 Memory1 에 저장하여 Memory1 에 저장 되어있는 누적교통량을 기반해서 탄력적으로 신호등의 주기를 조절하는 시스템을 구성하였습니다. <br/>
특히, 이번 프로젝트 에는 전체 신호등 시스템을 다수의 모듈로 나누고, 모듈들이 데이터 정보를 일방향으로 보내는 것이 아닌, 다른 모듈과 쌍방향으로 데이터를 주고 받는 것에 집중하여 설계를 진행하였습니다. <br/>
이때, 모듈간의 연결을 System Verilog 의 Interface 기능을 이용해 각 모듈이, 그리고 합친 전체 신호등 시스템이 모두 잘 작동하는지 확인하였습니다. <br/>
또한, 이런 확인 및 검증과정에서 System Verilog 의 Assertion 등을 활용해 다양한 입력 패턴을 이용해 Test Bench 를 작성해 시스템의 응답을 확인하였습니다. <br/>

## 2. 프로젝트 설계 및 구성
### 2-1. Circuit Diagram
<p align="center" style="margin: 20px 0;">
  <img width="90%" alt="Circuit Diagram" src="https://github.com/user-attachments/assets/dac83661-b667-426d-81ba-236f7f80f53c" />
</p>

### 2-2. System Description
&nbsp;우리가 만든 신호등 시스템은 총 다섯개의 system 이 상호작용한다. <br/>
다섯개의 시스템은 디지털 시계, 신호등, controller, memory, rank_calculator 로 구성된다. <br/>
각각의 역할은 다음과 같다. <br/>

<p align="center" style="margin: 20px 0;">
  <img width="90%" alt="Highway Image" src="https://github.com/user-attachments/assets/09e4ac0a-0f78-4d41-b25a-765b1f56c4fb" />
</p>

&nbsp;우리는 4 거리를 모델링 하여서 4 거리에 적용할 수 있는 신호등 시스템을 설계하였다. <br/>
기본적으로 우리가 모델링한 4 거리는 Main Highway 와 Country Road 2 개의 도로가 교차 되어있다. <br/>
Main Highway 는 고속도로의 개념으로 기본적으로 통행량이 많다. <br/>
Country Road 는 Main Highway 에 비하여 교통량이 적다. <br/>
따라서 Main Highway 의 파란불의 주기는 Country Road 의 파란불의 주기보다 더욱 짧게 설정하였다. <br/>

### 2-3. 각 System 역할
#### System 1. CLOCK
&nbsp;디지털 시계는 Controller, Memory에 시각 정보를 주어서 우리가 설계한 전체 시스템의 기준이 되는 시각정보를 제공하여 준다. <br/>
따라서 Controller 와 Memory 는 디지털 시계에서 제공해준 시간을 기준으로 신호등에 현재 시간대의 누적 교통량에 해당하는 주기를 결정한다. <br/>

#### System 2. TRAFFICLIGHT
&nbsp;우리가 설계한 전체 시스템은 Main Highway의 통행량과 Country Road에 정차되어 있는 자동차 대수를 기반으로 신호등의 주기가 결정된다. <br/>
이때 Main Highway의 교통량과 Country Road에 정차되어 있는 자동차의 대수는 신호등에 부착되어 있는 센서가 측정하여서 Controller에게 전달 시켜주도록 신호등을 모델링 하였다. <br/>
즉, 신호등에는 Main Highway의 교통량을 측정해주는 센서와 10초 동안 Country Road 에 새로 정차하는 자동차 대수를 측정해주는 센서 2개가 존재한다. <br/>

&nbsp;기본적으로 Testbench를 처음 시작할 때 Memory1 에 저장되어 있는 누적 교통량은 전부 0으로 초기화 되어있는 상태이다. <br/>
따라서 기본적으로 Setting 되어 있는 Main Highway 의 Green Light 의 주기는 3분이고 country road 의 green light 의 주기는 1 분이다. <br/>

&nbsp;이 상태에서 신호등은 신호등에 부착되어 있는 main highway 의 교통량을 측정하는 센서를 통하여 main highway 의 교통량을 측정한다. <br/>
Main highway 의 교통량을 측정하는 센서가 1 시간 동안 Main highway 의 현재 교통량을 측정하여서 1 시간 동안 측정된 교통량이 얼마나 많은 지 그 정도를 0 에서 4 까지 나누어 총 5 단계로 구분하여서 controller 에 전달하여 준다. <br/>

&nbsp;controller 에서 main highway 의 교통량을 받으면 memory1 과 rank_calculator 를 통해서 현재 시각이 하루 24 시간 중에서 교통량이 몇 순위인지 계산하여서 신호등에게 전달하여 준다. <br/>
그러면 신호등은 현재 시각에 맞는 누적 교통량이 하루 24 시간 중에서 몇 위인지 전달받는다. <br/>
그리고 이 순위를 기반으로 main highway 의 파란불 주기를 어떻게 할지 결정한다. <br/>

&nbsp;신호등에 부착되어 있는 또 다른 센서는 main highway 가 파란 불일 때 country road 는 빨간 불이므로 신호등에 부착되어있는 센서는 10 초 동안 country road 에 새로 정차하는 자동차 대수를 센다. <br/>
Main highway 의 파란 불 주기가 기본적으로 country road 의 파란 불 주기보다 훨씬 길기 때문에 country road 에 정차되어 있는 차량 대수가 많아질 때 도로가 막히는 현상을 해결해주기 위해서 이 기능을 추가했다. <br/>

&nbsp;country road 에 정차되어 있는 차량 대수가 많아질 때 도로가 막히는 현상을 해결해주기 위해서 이 기능을 추가했다. <br/>

&nbsp;신호등에 부착되어 있는 센서가 main highway 가 파란 불일 때 country road 에 정차되어 있는 자동차 대수를 측정해서 controller 에 전달해 주면 controller 는 내부적으로 계산을 하여서 country road 에 정차되어 있는 차량수가 일정 이상이 될 때 신호등에게 pulse 를 준다. <br/>
신호등은 이 pulse를 받으면 몇 clock 뒤에 main highway 를 빨간 불로 만들고 country road를 파란불로 만들어서 country road 에 정차되어 있는 자동차들을 통행하게 만들어 주어서 도로가 막히는 것을 방지할 수 있다. <br/>

#### System 3. CONTROLLER
&nbsp;Controller 가 받는 입력은 총 3 개이다. <br/>
첫 번째 입력은 신호등에게서 받는 현재 교통량 정보이고 두 번째 입력은 신호등에게서 받는 10 초동안 새로 country road 에 정차하는 자동차 대수이다. <br/>
마지막으로 세 번째 입력은 memory 에게서 받는 정보이다. <br/>
세 번째 입력은 총 15 비트로 구성되어 있고 앞의 10 비트는 현재 디지털 시계에서 주는 시간에 해당하는 구간의 총 누적 교통량이다. <br/>
이는 테스트 벤치가 시작 했을 때부터 현재까지 해당구간에서 측정된 교통량의 총합이다. <br/>
그리고 뒤의 5bit 는 memory1 에 누적된 교통량을 기반으로 현재 시각이 하루 24 시간 중에서 교통량이 몇 위인지를 담고 있다. <br/>
controller 의 기능은 총 2 개로 다음과 같다. <br/>
첫번째 기능은 memory1 이 주는 누적교통량과 신호등에서 주는 현재 교통량을 더한 후에 이 값을 디지털 시계에서 주는 현재 시간 정보와 합쳐서 memory1 에게 다시 전달하여 준다. <br/>
이 정보는 총 15bit 로 왼쪽 5bit 는 디지털 시계에서 주는 시간 정보를 저장하고 있고 오른쪽 10bit 는 현재 시각에 해당하는 계산된 누적교통량이다. <br/>
이 기능을 그림으로 나타내면 다음과 같다. <br/>

<p align="center" style="margin: 20px 0;">
  <img width="90%" alt="Controller Image" src="https://github.com/user-attachments/assets/4180848d-a0d1-49ef-99c2-8df5ac1c0399" />
</p>

&nbsp;두번째 기능은 10 초 동안 country road 에 새로 정차하는 자동차 대수를 신호등에서 주면 controller 는 이 값들을 모두 더하여 country road 에 정차되어 있는 차량이 30 대가 넘으면 신호등에게 pulse 를 준다. <br/>
이 때 controller 는 main highway 가 파란불 일 때만 country road 에 정차되어 있는
차량의 수를 더한다. <br/>
이렇게 하는 이유는 main highway 가 빨간 불이 되면 country road 는 파란불이 되어 country road 에 정차 되어 있는 차들이 통행을 할 수 있기 때문이다. <br/>

#### System 4. MEMORY

<p style="margin: 20px 0;">
  <img width="30%" alt="Memory1 Image" src="https://github.com/user-attachments/assets/80a66ed8-d673-4285-917d-f90060125a47" />
</p>

&nbsp;memory1 은 controller, 디지털 시계, rank_cal 3 개에서 모두 입력을 받는다. <br/>
controller 로 부터는 누적 교통량을 받고 디지털 시계로 부터는 현재 시간을 받고 rank_cal 에서는 시간대별 누적 교통량의 순위를 받는다. <br/>

&nbsp;그리고 memory1 은 각각의 모듈로 부터 받은 정보를 24 개의 시간의 구간별로 누적 교통량과 순위정보를 갱신한다. <br/>

#### System 5. RANK_CALCULATOR

<p style="margin: 20px 0;">
  <img width="30%" alt="Rank_cal Image" src="https://github.com/user-attachments/assets/daf162c2-07cd-4378-9257-3a4f8c8fe4d9" />
</p>

&nbsp;Rank_cal 시스템은 Memory1 으로 부터 입력 15bit 를 받는다. <br/>
이때 Rank_cal 의 입력으로 들어오는 15bit 의 왼쪽 5bit 는 시간 정보이고 오른쪽 10bit 는 누적교통량 정보이다. <br/>
그러면 Rank_cal 은 위와 같이 구성된 15bit 를 받으면 해당 시각에 누적 교통량이 몇 위인지 시간에 따라 순위를 내림차순 정렬을 해준다. <br/>

## 3. 각 System 설명
### System 1. CLOCK

<p center="align" style="margin: 20px 0;">
  <img width="90%" alt="CLOCK Schematic" src="https://github.com/user-attachments/assets/7e2a6bd6-77ea-4219-9bc2-fe27b33bcc69" />
</p>

&nbsp;<strong>전용면적: 5859.13 (sq um)</strong> <br/>

&nbsp;Clock 모듈은 시간 값을 출력한다. Clk 을 받아서 시간을 생성하고 각 모듈에 시간 값을 뿌려준다. <br/>
다른 모듈들은 그 시간 값을 참고하여 값을 저장하거나 traffic 을 통제한다. <br/>

``` systemverilog
   always_ff @(posedge i0.CLK) begin
      if (i0.SECOND == 29) begin
	 S_CLK <= ~S_CLK;
	 i0.SECOND <= i0.SECOND + 1;
      end
      else if (i0.SECOND == 59) begin
	 i0.SECOND <= 0;
	 S_CLK <= ~S_CLK;
      end
      else begin
	 i0.SECOND <= i0.SECOND + 1;
      end
   end // always_ff @ (posedge i0.CLK or negedge rstn)
```

이 블록은 CLK 을 통해서 SECOND를 생성하는 부분이다. <br/>
S_CLK 신호는 다음 신호인 MINUTE 신호를 동기화 시키는데 사용된다. 
S_CLK 신호가 1 부터 시작하면서 30 초후 0 으로 바뀌고 다시 30 초후 1 로 바뀐다. <br/>
이때, 0 에서 1 로 바뀌는 신호는 MINUTE Block 의 동기화 신호로 아래와 같이 들어간다. <br/>


``` systemverilog
  always_ff @(posedge S_CLK) begin
      if (i0.MINUTE == 29) begin
	 M_CLK <= ~M_CLK;
	 i0.MINUTE <= i0.MINUTE + 1;
      end
      else if (i0.MINUTE == 59) begin
	 i0.MINUTE <= 0;
	 M_CLK <= ~M_CLK;
      end
      else begin
	 i0.MINUTE <= i0.MINUTE + 1;
      end
   end // always_ff @ (posedge S_CLK or negedge i0.rstn)
```

&nbsp;이 블록도 SECOND 블록과 마찬가지이다. <br/>
M_CLK이 시간을 생성하는 블록의 동기화 신호가 된다. <br/>

``` systemverilog
   always_ff @(posedge M_CLK) begin
      if (i0.HOUR == 23) begin
	 i0.HOUR <= 0;
      end
      else begin
	 i0.HOUR <= i0.HOUR + 1;
      end
   end // always_ff @ (posedge M_CLK or negedge i0.rstn)
```

&nbsp;CLK(Input) : 클럭 입력신호로 이 모듈의 동기신호 이다. <br/>
SECOND, MINUTE, HOUR(Output) : 시간, 분, 초의 각각의 Output 이다. <br/>

### System 2. TRAFFICLIGHT

<p center="align" style="margin: 20px 0;">
  <img width="90%" alt="TRAFFICLIGHT Schematic" src="https://github.com/user-attachments/assets/1a84d8fc-e231-4a68-be32-908b0f1dff72" />
</p>

&nbsp;<strong>전용면적: 7797 (sq um)</strong>

``` systemverilog
module TRAFFICLIGHT(SYSTEM_BUS.TRAFFIC_LIGHT i2);

   enum logic [1:0] {S0 = 2'b00, S1, S2, S3} STATE;
	typedef enum logic [1:0] {RED = 2'b00, GREEN, YELLOW} LIGHTSTATE;
   logic PREV_PULSE, FINAL_PULSE, MAIN_CNT_ENABLE, CNTRY_CNT_ENABLE = 1'b0;
   logic [8:0] CNT = 0;

   LIGHTSTATE MAINLIGHT = GREEN;
   LIGHTSTATE CNTRYLIGHT = RED;
...
```

&nbsp;내부에서 사용하는 logic 은 다음과 같다. <br/>
typedef enum logic [1:0] {RED = 2’b00, GREEN, YELLO} lightState : FSM 을 쉽게 사용하기 위한 열거형 type 선언. <br/>
enum logic [2:0] {S0 = 2’b00, S1, S2, S3} state : state 는 FSM 을 이용하여 main highway 와 country highway 의 신호등을 결정. <br/>
prevPulse : controller 에서 받아오는 펄스를 저장. <br/>
finalPulse : prevPulse 를 이용하여 1 을 띄우게 함. <br/>
mainCntEnable : main highway 의 초록불의 주기를 clock 에 따라 count 하기 위해 필요한 신호. <br/>
cntryCntEnable : country highway 의 초록불의 주기를 clock 에 따라 count 하기 위해 필요한 신호. <br/>

``` systemverilog
   always_ff @(posedge i2.CLK) begin
      i2.CURRENT_TRAFFIC_AMOUNT <= i2.MAIN_TRAFFIC;
      i2.COUNTRY_CAR_NUM <= i2.COUNTRY_TRAFFIC;
      i2.MAIN_LIGHT <= MAINLIGHT;
      i2.MAINLIGHT <= MAINLIGHT;
      i2.COUNTRYLIGHT <= CNTRYLIGHT;
      
      if (MAIN_CNT_ENABLE == 1'b1) begin
	 if (i2.LIGHT_RANK[4:0] inside {5'b00001, 5'b01000}) begin
	    if (CNT >= (750 - (5'd40 * i2.LIGHT_RANK[4:0]))) begin
	       STATE <= S1;
	       MAIN_CNT_ENABLE <= 1'b0;
	       CNT <= 0;
	    end
	    else
	      CNT <= CNT + 1;
	 end
	 else begin
	    if (CNT >= 360) begin
	       STATE <= S1;
	       MAIN_CNT_ENABLE <= 1'b0;
	       CNT <= 0;
	    end
	    else
	      CNT <= CNT + 1;
	 end // else: !if(i2.LIGHT_RANK inside {5'b00001, 5'b01010})
      end // if (MAIN_CNT_ENABLE == 1'b1)
      else if (CNTRY_CNT_ENABLE == 1'b1) begin
	 if (FINAL_PULSE == 1'b1) begin
	    if (CNT >= 240) begin
	       STATE <= S3;
	       CNTRY_CNT_ENABLE <= 1'b0;
	       FINAL_PULSE <= 1'b0;
	       CNT <= 0;
	    end
	    else
	      CNT <= CNT + 1;
	 end
	 else begin
	    if (CNT >= 120) begin
	       STATE <= S3;
	       CNTRY_CNT_ENABLE <= 1'b0;
	       CNT <= 0;
	    end
	    else
	      CNT <= CNT + 1;
	 end // else: !if(FINAL_PULSE == 1'b1)
      end // if (CNTRY_CNT_ENABLE == 1'b1)
      else
	CNT <= 0;
   end // always_ff @ (posedge i2.CLK)

   always_ff @(posedge i2.CLK) begin
      PREV_PULSE <= i2.COUNTRY_PULSE;
      if ((i2.COUNTRY_PULSE == 1'b0) && (PREV_PULSE == 1'b1))
	FINAL_PULSE <= 1'b1;
      else begin
	 case (STATE)
	   S0 : begin
	      if (FINAL_PULSE == 1'b1)
		STATE <= S1;
	      else
		MAIN_CNT_ENABLE <= 1'b1;
	   end
	   S1 : begin
	      MAIN_CNT_ENABLE <= 1'b0;
	      STATE <= S2;
	   end
	   S2 : CNTRY_CNT_ENABLE <= 1'b1;
	   S3 : begin
	      CNTRY_CNT_ENABLE <= 1'b0;
	      STATE <= S0;
	   end
	   default : STATE <= S0;
	 endcase // case (STATE)
      end // else: !if((i2.COUNTRY_PULSE == 1'b0) && (PREV_PULSE == 1'b1))
   end // always_ff @ (posedge i2.CLK)

   always @(*) begin
      case (STATE)
	S0 : MAINLIGHT = GREEN;
	S1 : MAINLIGHT = YELLOW;
	S2 : MAINLIGHT = RED;
	S3 : MAINLIGHT = RED;
	default : MAINLIGHT = GREEN;
      endcase // case (STATE)
   end

   always @(*) begin
      case (STATE)
	S0 : CNTRYLIGHT = RED;
	S1 : CNTRYLIGHT = RED;
	S2 : CNTRYLIGHT = GREEN;
	S3 : CNTRYLIGHT = YELLOW;
	default : CNTRYLIGHT = RED;
      endcase // case (STATE)
   end
...
```

&nbsp;구동원리 : FSM 을 이용하여, state 별로 동작하게 한다. <br/>

&nbsp;S0 (main : GREEN, country : RED) <br/>
mainCntEnable 동작 -> main highway 의 초록불 -> cnt 의 counter 기능 활성화 -> inside 를 이용하여 우선순위를 받을시, 받아온 우선 순위를 이용하여 cnt 가 730 - (40 * 우선순위)가 넘어갈시 S1 으로 이동. <br/>
그렇지 않다면, 신호등 기본 주기인 360 clock 뒤에 S1 으로 이동하도록 설계. <br/>

&nbsp;S1 (main : YELLOW, country : RED) <br/>
main highway 의 노란불 -> 다음 클락에 S2 로 이동하도록 설계. <br/>

&nbsp;S2 (main : RED, country : GREEN) <br/>
cntryCntEnable 동작 -> country highway 의 초록불 -> cnt 의 counter 기능 활성화 -> 단, finalPulse 가 있을 시, country highway 의 차량이 30 대
이상이므로 country highway 의 GREEN 주기를 240 clock 으로 늘려줌. <br/>
그렇지 않다면, 신호등 기본 주기인 120 clock 뒤에 S3 로 이동하도록 설계. <br/>

&nbsp;S3 (main : RED, country : YELLOW) <br/>
country highway 의 노란불 -> 다음 클락에 S0 로 이동하도록 설계. <br/>

&nbsp;이처럼, FSM 을 이용하여 간단한 신호등 모듈을 만들고, 외부적 요소들은 조건문을 추가하여 설계하였다. <br/>

&nbsp;* controller 의 (0 -> 1 -> 0) pulse 를 1 의 신호로 변경하기 : prevPulse 에 controller 에서 주는 pulse(1)를 저장한 뒤, 현 clock 에서의 prevPulse == 0, 다음 clock 에서 prevPulse == 1 이 되는 것을 이용하여, finalPulse 를 1 로 변경. <br/>

### System 3. CONTROLLER

<p center="align" style="margin: 20px 0;">
  <img width="90%" alt="CONTROLLER Schematic" src="https://github.com/user-attachments/assets/53c4ec59-86e8-4042-956c-8d0788d1f56c" />
</p>

&nbsp;<strong>전용면적: 8653.63 (sq um)</strong>

&nbsp;controller 모듈은 교차 도로와 메인 도로의 신호 상태와 교통량을 관리하며, 특정 조건에서 신호 제어 펄스를 생성한다. <br/>
교차 도로의 누적 차량 수를 계산하고, 교통량 변화에 따라 메모리 작업 상태를 설정한다. <br/>
또한, 누적 교통량 데이터를 기반으로 신호등 순위를 결정한다. <br/>

``` systemverilog
module CONTROLLER (SYSTEM_BUS.CONTROLLER i1);

   logic [6:0] COUNTRY_CAR_NUMBER = 0;
   bit [2:0] PREV_COUNTRY_CAR_NUM, PREV_CURRENT_TRAFFIC_AMOUNT;
   MEM_OP OP;
...
```

&nbsp;country_car_number: 이 신호는 교차 도로의 누적 차량 수를 저장하는 역할을 한다. <br/>
교차 도로의 차량 수가 업데이트될 때마다 증가하며, 일정 수치(예: 30)를 초과할 경우 신호 제어 펄스를 활성화한다. <br/>
7 비트로 구성되어 있으며, 초기값은 0 으로 설정된다. <br/>

&nbsp;prev_country_car_num: 이 신호는 이전 클럭 사이클에서의 교차 도로 차량 수를 저장한다. <br/>
현재 교차 도로 차량 수와 비교하여 변화가 있는지 확인하는 데 사용된다. <br/>
3 비트로 구성되어 있다. <br/>

&nbsp;prev_current_traffic_amount: 이 신호는 이전 클럭 사이클에서의 메인 도로의 현재 교통량을 저장한다. <br/>
현재 교통량과 비교하여 변화가 있는지 확인하는 데 사용된다. <br/>
3 비트로 구성되어 있다. <br/>

&nbsp;첫 번째 always_ff 블록에 대해서 설명하겠다. <br/>

``` systemverilog
...
   always_ff @(posedge i1.CLK) begin
      PREV_COUNTRY_CAR_NUM <= i1.COUNTRY_CAR_NUM;
      PREV_CURRENT_TRAFFIC_AMOUNT <= i1.CURRENT_TRAFFIC_AMOUNT;
   end
...
```

&nbsp;이 블록은 교차 도로의 차량 수와 메인 도로의 교통량을 업데이트하는 역할을 한다. <br/>
이전 값을 현재 값으로 저장하여 다음 클럭 사이클에서 비교할 수 있도록 한다. <br/>

``` systemverilog
   always_ff @(posedge i1.CLK) begin
      if (i1.COUNTRY_CAR_NUM != PREV_COUNTRY_CAR_NUM) begin
	 if (i1.MAIN_LIGHT[0] == 1) begin
	    COUNTRY_CAR_NUMBER <= COUNTRY_CAR_NUMBER + i1.COUNTRY_CAR_NUM;
	    if (COUNTRY_CAR_NUMBER > 30) begin
	       i1.COUNTRY_PULSE <= 1;
	       COUNTRY_CAR_NUMBER <= 0;
	    end
	    else begin
	       i1.COUNTRY_PULSE <= 0;
	    end
	 end
	 else if (i1.MAIN_LIGHT[0] == 0) begin
	    COUNTRY_CAR_NUMBER <= 0;
	    i1.COUNTRY_PULSE <= 0;
	 end
      end // if (i1.COUNTRY_CAR_NUM != PREV_COUNTRY_CAR_NUM)
      else begin
	 i1.COUNTRY_PULSE <= 0;
      end // else: !if(i1.COUNTRY_CAR_NUM != PREV_COUNTRY_CAR_NUM)
   end // always_ff @ (posedge i1.CLK)
```

&nbsp;이 블록은 교차 도로의 차량 수를 관리하고, 메인도로의 신호 상태에 따라 교차 도로 신호 제어 펄스를 생성한다. <br/>

&nbsp;country_car_num 가 prev_country_car_num 과 다를 경우, 즉 교차 도로의 차량 수가 변화한 경우에 실행된다. <br/>
예를들어 메인도로 신호가 녹색(light[0] == 1)일 때 누적 차량 수(country_car_number)에 현재 차량 수(country_car_num)를 더한다. <br/>
누적 차량 수가 30 을 초과하면, 신호 제어 펄스(country_pulse)를 활성화(1)하고, 누적 차량 수를 초기화한다. <br/>

&nbsp;그렇지 않으면, 신호 제어 펄스를 비활성화(0)한다. <br/>
메인도로 신호가 녹색이 아닌 경우(light[0] == 0) 누적 차량 수와 신호 제어 펄스를 초기화한다. <br/>
교차 도로의 차량 수가 이전 값과 동일한 경우 신호 제어 펄스를 비활성화한다. <br/>

``` systemverilog
...
   always_ff @(posedge i1.CLK) begin
      if (i1.CURRENT_TRAFFIC_AMOUNT != PREV_CURRENT_TRAFFIC_AMOUNT) begin
	 i1.OP1 <= WRITE;
	 i1.ACCUM_DATA1[14:10] <= i1.HOUR;
	 i1.ACCUM_DATA1[9:0] <= i1.CURRENT_TRAFFIC_AMOUNT + i1.ACCUM_DATA2[14:5];
      end
      else if (i1.OP2 == WRITE)
	 i1.LIGHT_RANK[4:0] <= i1.ACCUM_DATA2[4:0];
      else
	i1.OP1 <= READ;
   end // always_ff @ (posedge i1.CLK)
...
```

&nbsp;이 블록은 현재 교통량을 관리하고, 메모리 작업 상태를 설정하며, 누적 교통량 데이터를 계산한다. <br/>

&nbsp;current_traffic_amount 가 prev_current_traffic_amount 와 다를 경우, 즉 현재 교통량이 변화한 경우에 실행된다. <br/>
현재 교통량이 이전 값과 다른 경우 메모리 작업 상태(op)를 쓰기(WRITE)로 설정한다. <br/>
현재 시간(hour)을 누적 데이터(accum_data1)의 상위 5 비트에 저장한다. <br/>
현재 교통량(current_traffic_amount)과 이전에 누적된 교통량(accum_data2 의 상위 10 비트)을 더해 누적 데이터(accum_data1)의 하위 10 비트에 저장한다. <br/>

&nbsp;현재 교통량이 이전 값과 같은 경우 메모리 작업 상태(op)를 읽기(READ)로 설정한다. <br/>

### System 4. MEMORY

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="MEMORY Schematic" src="https://github.com/user-attachments/assets/0345ca4f-2463-46a6-80ba-f28a7566c457" />
</p>

&nbsp;<strong>전용면적: 212382.00 (sq um)</strong>

&nbsp;memory1 모듈은 시간대별로 교통량과 순위 데이터를 저장하고 업데이트하는 역할을 한다. <br/>
이 모듈은 컨트롤러로부터 받은 교통량 정보를 특정 시간대에 저장하며, Rank_Cal 로부터 받은 순위 데이터를 기반으로 교통량 순위를 업데이트한다. <br/>
저장된 데이터는 다른 모듈로 전송되어 교통 상태를 관리하는 데 사용된다. <br/>
또한, 현재 시간대의 교통량과 순위 데이터를 컨트롤러에 제공한다. <br/>

``` systemverilog
module MEMORY (SYSTEM_BUS.MEM i3);

   bit [19:0] MEMORY[23:0];
   bit [4:0]		i;
...
```

&nbsp;* memory 배열 (bit [19:0] memory[23:0]): 이 배열은 24 개의 20 비트 데이터를 저장하는 메모리이다. 각 시간대별로 데이터를 저장할 수 있도록 설계되었다. 상위 5 비트는 시간 정보 중간 10 비트는 교통량 정보 마지막 하위 5 비트는 교통량 순위 정보를 담고 있다. <br/>

&nbsp;* 반복문 인덱스 (bit [4:0] i): i 는 for 루프에서 사용되는 반복문 인덱스이다. 메모리와 데이터 배열을 순회하며 데이터를 읽거나 쓸 때 사용된다. bit[4:0]은 5 비트 크기의 인덱스를 의미한다. 5 비트는 0 부터 31 까지의 값을 표현할 수 있으므로, 24 개의 데이터 인덱스를 순회하는 데 충분하게 사용할 수 있다. <br/>

``` systemverilog
...
   always_ff @(posedge i3.CLK) begin
      if (i3.OP1 == WRITE) begin
	 MEMORY[i3.HOUR][19:5] <= i3.ACCUM_DATA1[14:0];
	 for (i = 0; i < 24; i ++) begin
	    i3.TRAFFIC_DATA[i][14:0] <= MEMORY[i][19:5];
	 end
      end
      else if (i3.OP2 == WRITE) begin
	 for (i = 0; i < 24; i ++) begin
	    MEMORY[i][4:0] <= i3.TRAFFIC_RANKED_DATA[i][4:0];
	 end
	 i3.ACCUM_DATA2[14:0] <= MEMORY[i3.HOUR][14:0];
      end
      else begin
	 MEMORY[i3.HOUR][19:5] <= i3.ACCUM_DATA1[14:0];
	 i3.ACCUM_DATA2[14:0] <= MEMORY[i3.HOUR][14:0];
      end
   end // always_ff @ (posedge i3.CLK)
...
```

&nbsp;always_ff 블록은 클럭 신호 (clk)의 상승 에지에서 동작한다. <br/>
이 블록은 주어진 연산 명령 (op1 및 op2)에 따라 메모리 읽기 및 쓰기 작업을 수행하며 누적 교통량 데이터와 교통량 순위 데이터를 관리한다. <br/>

&nbsp;* WRITE 동작 (op1 이 WRITE 일 때) <br/>
op1 이 WRITE 인 경우, 현재 시간 (hour)에 해당하는 메모리 위치에 누적 교통량 데이터 (accum_data1[14:0])를 저장한다. <br/>
메모리의 상위 15 비트([19:5])에 저장된다. <br/>
모든 시간대에 대해 누적 교통량 데이터를 traffic_data 배열에 갱신한다. <br/>
메모리의 상위 15 비트 ([19:5])를 traffic_data 의 각 시간대 위치에 복사한다. <br/>

&nbsp;* WRITE 동작 (op2 가 WRITE 일 때) <br/>
op2 가 WRITE 인 경우, 모든 시간대에 대해 교통량 순위 데이터를 메모리에 갱신한다. <br/>
각 시간대의 교통량 순위 데이터 (traffic_ranked_data[i][4:0])를 메모리의 하위 5 비트 ([4:0])에 저장한다. <br/>
현재 시간 (hour)에 해당하는 메모리 위치에서 누적 교통량과 순위 데이터를 읽어와서 accum_data2 에 저장한다. <br/>

&nbsp;* 기본 동작 (READ 동작) <br/>
기본 동작으로, op1 이 READ 일 때와 유사하게 현재 시간 (hour)에 해당하는 메모리 위치에 누적 교통량 데이터를 저장하고 (accum_data1[14:0]), 그 위치에서 누적 교통량과 순위 데이터를 읽어와서 accum_data2 에 저장한다. <br/>

&nbsp;memory1 은 위와 같은 로직에 의해서 입력된 데이터를 메모리에 저장하고, 저장된 데이터를 출력 포트로 제공한다. <br/>
따라서 외부에 의해 연산 명령이 주어지면 메모리의 읽기 및 쓰기 작업을 수행할 수 있다. <br/>

### System 5. RANK_CALCULATOR

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="RANK_CALCULATOR Schematic" src="https://github.com/user-attachments/assets/92a25f97-47a5-495f-89c4-9f8aee886155" />
</p>

&nbsp;<strong>전용면적: 416855.56 (sq um)</strong>

&nbsp;rank_cal 모듈은 Memory 로부터 받은 시각, 교통량의 정보를 교통량의 순서대로 정렬해 출력으로 현재 시각과 해당하는 순위른 다시 Memory에 보낸다. <br/>
순위는 1 부터 24 로 나타나며 입력이 들어오지 않은 시각대에서 순위를 0 으로 보낸다. <br/>

``` systemverilog
...
	always_comb begin
			for (i = 0; i < 24; i ++) begin
				RANK[i] = 0;
			end
			for (i = 0; i < 24; i ++) begin
				for (j = 0; j < 24; j ++) begin
					if (INPUT_DATA[i][9:0] < INPUT_DATA[j][9:0]) begin
						RANK[i] = RANK[i] + 1;
					end
				end
			end
...
```

&nbsp;들어온 24 개 시각에 대해 우선 출력으로 나가는 순위 정보를 모두 0 으로 초기화 한다. <br/>
다음으로 반복문을 사용하여 하나의 input 의 교통량을 다른 모든 23 개의 input 의 교통량과 비교한다. <br/>
만약 교통량이 적다면 순위는 하나씩 더해져 뒤로 밀려난다. <br/>
만약 같은 순위가 2 개 나오다면 다음 중복되는 수만큼 순위가 뒤로 밀려난다.(ex. 1 2 3 3 3 6 위 …) <br/>

``` systemverilog
...
		for (i = 0; i < 24; i ++) begin
			if (INPUT_DATA[i][9:0] >= 10'b00000_00000) begin
				RANK[i] = RANK[i] + 1;
			end
		end
...
```

&nbsp;위 코드에서 순위의 초기값을 0 으로 설정했기에 순위를 모두 1 더해줘 1 부터 시작하게 만든다. <br/>
대신 input 이 들어온 경우만 한해서 순위가 개선되고 입력이 들어오지 않은 시간대에는 순위가 여전히 0 이 나타나게 된다. <br/>

``` systemverilog
		for (i = 0; i < 24; i ++) begin
			if (INPUT_DATA[i][9:0] >= 10'b00000_00000) begin
				RANKED_DATA[i] = {INPUT_DATA[i][14:10], RANK[i]};
			end
			else begin
				RANKED_DATA[i] = {i, 5'b00000};
			end
		end
	end
endmodule
```

&nbsp;Memory 에게 다시 데이터를 보내주기 위해서 10bit 정보를 구성한다. <br/>
상위 5bit 에는 입력에 해당하는 현재 시각 정보가, 하위 5bit 에는 내부 logic 으로 저장된 rank 값이 할당 된다. <br/>
따라서 입력이 존재한다면 현재 시각과 그에 해당하는 교통량의 순위가 10bit 로 구성되 출력으로 나온다. <br/>
입력이 없는 경우 rank 에 내부 logic 으로 0 이 저장되어 있기 때문에 입력으로 들어오지 않은 시각의 순위는 0 으로 출력이 나타난다. <br/>

## 4. Module Verification
### 4-1. Interface

``` systemverilog
interface SYSTEM_BUS (
		      input logic CLK,
		      input logic [2:0] MAIN_TRAFFIC,
		      input logic [2:0] COUNTRY_TRAFFIC,
		      output logic [1:0] COUNTRYLIGHT,
		      output logic [1:0] MAINLIGHT
		      );

   logic 				 COUNTRY_PULSE = 0;
   logic [1:0] 				 MAIN_LIGHT;
   logic [2:0] 				 CURRENT_TRAFFIC_AMOUNT;
   logic [2:0] 				 COUNTRY_CAR_NUM;
   bit [4:0] 				 HOUR, LIGHT_RANK;
   bit [5:0] 				 MINUTE, SECOND;
   bit	 [14:0] 			 ACCUM_DATA1, ACCUM_DATA2;
   bit	 [9:0] 				 TRAFFIC_RANKED_DATA [23:0];
   bit	 [14:0] 				 TRAFFIC_DATA [23:0];
   MEM_OP OP1;
   MEM_OP OP2;
...
```

&nbsp;위 신호등 시스템에서 Interface 를 통해서 연결한 것을 확인하면 신호등 내부에 수많은 데이터 정보의 흐름이 존재하지만, 우리가 관심있는 영역에 대해서 Interface 를 통해 묶고 나머지는 내부 변수로 처리했음을 알 수 있다. <br/>

``` systemverilog
...
   modport CLOCK (
		  input CLK,
		  output HOUR, MINUTE, SECOND
		  );

   modport CONTROLLER (
		       input MAIN_LIGHT, CURRENT_TRAFFIC_AMOUNT, COUNTRY_CAR_NUM, ACCUM_DATA2, HOUR, CLK, OP2,
		       output COUNTRY_PULSE, LIGHT_RANK, ACCUM_DATA1, OP1
		       );

   modport TRAFFIC_LIGHT (
			  input COUNTRY_PULSE, LIGHT_RANK, MAIN_TRAFFIC, COUNTRY_TRAFFIC, CLK,
			  output MAINLIGHT, MAIN_LIGHT, COUNTRYLIGHT, CURRENT_TRAFFIC_AMOUNT, COUNTRY_CAR_NUM
			  );

   modport MEM (
		 input HOUR, ACCUM_DATA1, TRAFFIC_RANKED_DATA, CLK, OP1, OP2,
		 output TRAFFIC_DATA, ACCUM_DATA2
		 );

   modport RANK_CAL (
		 input TRAFFIC_DATA, HOUR, MINUTE, SECOND, CLK, OP1,
		 output TRAFFIC_RANKED_DATA, OP2
		 );

endinterface // SYSTEM_BUS
```

&nbsp;System Verilog 의 modport 는 Interface 의 특정 신호에 대한 접근 권한을 정의하는데 사용되며 이를 통해 인터페이스를 사용하는 모듈의 역할에 따라 신호의 입출력 방향을 명확히 설정할 수 있다. <br/>

### 4-2. Randomize Testbench Input

``` systemverilog
...
      for (int j = 0; j < 120; j ++) begin
	 for (int i = 0; i < 120; i ++) begin
	    COUNTRY_TRAFFIC = (PREV_TB_COUNTRY_TRAFFIC + 3'b001 + i) % 8;
	    if (COUNTRY_TRAFFIC == PREV_TB_COUNTRY_TRAFFIC)
	      COUNTRY_TRAFFIC = (COUNTRY_TRAFFIC + 3'b001) % 8;
	    PREV_TB_COUNTRY_TRAFFIC = COUNTRY_TRAFFIC;
	    #60;
	 end
	 MAIN_TRAFFIC = (PREV_TB_M_TRAFFIC + 3'b001 + j) % 5;
	 if (MAIN_TRAFFIC == PREV_TB_M_TRAFFIC)
	   MAIN_TRAFFIC = (MAIN_TRAFFIC + 3'b001) % 5;
	 PREV_TB_M_TRAFFIC = MAIN_TRAFFIC;
      end
      #1000
	$finish();
   end
```

&nbsp;randomize 를 license 때문에 사용할 수 없기 때문에 임의로 randomize 하게 보이는 testbench 를 구현했다. <br/>
이 system 에서는 2ns 를 1 초라고 정의하였다. <br/>
120 까지 도는 for 문 2 개를 이용했는데 중첩하여 이용했다. <br/>
내부 for 문에 60 의 delay 를 주어서 7200ns 즉 1 시간을 120 번 돌아서 5 일동안 동작하게 구현하였다. <br/>
그리고 main 교통량을 구현할때 이전 교통량을 저장해두고 해당인덱스를 더하고 5 로 나누어서 0~4 까지로 교통량을 수치화하였다. <br/>
이전 교통량에 인덱스를 더하고 나누어 주면서 testbench 를 실행했을때 무작위 처럼 보이는 교통량 입력을 주었다. <br/>

### 4-3. Assertion(Immediate, Not Concurrent)

&nbsp;sequential logic 을 사용한 시스템으로서, concurrent assertions 을 사용해야 하지만, license 문제로 인해 immediate assertions 을 사용해야만 했다. <br/>
이는, combinational logic 을 위한 검증으로 본 시스템에는 다소 맞지 않다. <br/>

&nbsp;아래는, 각 모듈에서 중요한 신호나 logic 을 위한 <span style="color:red">6 가지의 assertion</span> 이다. <br/>
각각의 시스템은 이와같이 동작할 것을 암시한다. <br/>

&nbsp;<strong><u>저희가 설계한 시스템은 아래와 같이 많은 assertion 을 이용함으로써 스마트한 검증이라는 설계 스펙에 최대한 부합하게 설계하였습니다.</strong></u> <br/>

&nbsp;CONTROLLER : CHECK_PULSE, CHECK_ACCUM_DATA <br/>
&nbsp;TRAFFICLIGHT : CHECK_FINAL_PULSE, CHECK_CNT <br/>
&nbsp;MEMORY : CHECK_ACCUM_EQUAL <br/>
&nbsp;RANK_CALCULATOR : CHECK_RANK <br/>

#### 4-3-1. Memory Overflow

<p center="align" style="margin: 20px 0;">
	<img width="49%" alt="Memory Overflow Code Image1" src="https://github.com/user-attachments/assets/c5d2db38-c54b-44b2-b9ff-70c2714ee983" />
	<img width="49%" alt="Memory Overflow Code Image2" src="https://github.com/user-attachments/assets/2f569fbe-8f99-4d76-a138-f0e1162e9b33" />
</p>

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="Memory Overflow Log Image" src="https://github.com/user-attachments/assets/e2e3a9a5-7ae9-40f9-b09e-361ea9fefaf4" />
</p>

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="Memory Overflow Waveform Image" src="https://github.com/user-attachments/assets/38fad131-5f5f-489c-b541-03eb9200a949" />
</p>

&nbsp;첫 번째 사진은 controller 모듈의 일부이다. <br/>
controller 는 메모리가 controller 에게 주는 정보인 accum_data2 와 현재 main highway 의 traffic 정보인 current_traffic_amount 를 덧셈 연산하여 accum_data1 에 전달해 준다. <br/>
이때 60~61 번째 줄을 확인하면 assert 구문의 활용을 볼 수 있다. <br/>
해당 assert 구문은 교통량 정보를 축적하여 저장하는 메모리가 오버플로우 나는 경우를 탐지한다. <br/>
테스트 벤치에서 강제로 current_traffic_amount 와 연결된 mainToCtrl 에 10’b1111111111 의 값을 넣어 주었고 fatal 에 의해서
정지되었다. <br/>
파형과 로그 확인 결과 세번째 사진의 62 번째 줄에 로그가 떠있는 것을 확인 할 수 있고 시뮬레이션 파형에서도 멈춘것을 확인 할 수 있다. <br/>

### 4-3-2. CHECK_PULSE, CHECK_FINAL_PULSE

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="CHECK_PULSE, CHECK_FINAL_PULSE Log Image" src="https://github.com/user-attachments/assets/37b6f0a6-3dbd-4659-bda7-ae0807eafbac" />
</p>

&nbsp;위의 time 은 1ns 의 기준이다. <br/>
사진과 같이 CHECK_PULSE FAIL 이 45ns, CHECK_FINAL_PULSE FAIL 이 47ns 에서 발생한다. <br/>
이는 concurrent assertion 으로 검증을 해야한다. <br/>

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="CHECK_PULSE, CHECK_FINAL_PULSE Waveform Image" src="https://github.com/user-attachments/assets/7bec4023-369c-4a53-bf59-851a4f3124a2" />
</p>

&nbsp;country road 의 누적 차량 대수가 30 이 이상이 됐을 시, pulse 가 발생하는 것을 알 수 있다. <br/>
pulse 가 발생하고 다음 클락에 finalPulse 가 발생하게 되는데 선언한 assertion 은 클락의 기준이 아니므로, FAIL 이 뜰 수도 있고 PASS 가 뜰 수도 있다. <br/>

### 4-3-3. CHECK_CNT

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="CEHCK_CNT Log Image" src="https://github.com/user-attachments/assets/16cd5ed6-ff07-4d95-b74c-1f8805828996" />
</p>

&nbsp;1269ns 에서 CNT PASS 가 발생한다. 이는 신호등의 주기를 세어주는 cnt 값이 360 이상이 되었다는 뜻이다. <br/>

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="CHECK_CNT Waveform Image" src="https://github.com/user-attachments/assets/4bcf8291-849e-4fd2-9ff2-7f24d11427fb" />
</p>

&nbsp;다음과 같은 사진을 보면, main highway 의 신호등이 파란불이 되는 시기부터 1269ns 까지는 신호등의 초록불 주기가 기본주기인 것이다. <br/>
이는 우선순위 light_rank 를 trafficLight 모듈이 받았으므로, 기본주기보다 훨씬 더 길어진 것이다. <br/>

### 4-3-4. CHECK_ACCUM_EQUAL, CHECK_RANK

<p style="margin: 20px 0;">
	<img width="40%" alt="CHECK_ACCUM_EQUAL, CHECK_RANK Log Image" src="https://github.com/user-attachments/assets/cf869d6d-2f70-4d2d-bbe0-a8da6756c360" />
</p>

&nbsp;위의 사진을 보면, CHECK_RANK PASS 가 9ns 에서 발생하고, CHECK_RANK PASS 가 11ns 에서 발생하는 것을 알 수 있다. <br/>

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="CHECK_ACCUM_EQUAL, CHECK_RANK Waveform Image1" src="https://github.com/user-attachments/assets/91c70790-3b24-4bbc-95d7-f283bfdca544" />
</p>

&nbsp;9ns 에서의 accum_data1[9:0]과 accum_data2[14:5]의 누적 교통량 수가 같아짐을 알 수 있다. <br/>
이는 memory 와 rank_calculator 모듈이 정상 동작을 한다는 것을 알 수 있다. <br/>

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="CHECK_ACCUM_EQUAL, CHECK_RANK Waveform Image2" src="https://github.com/user-attachments/assets/84d936e4-dea5-4fa8-9d29-960b6b641a42" />
</p>

&nbsp;op1 == read 상태일 때, traffic_ranked_data[i4.hour][4:0]를 내보내는지를 나타낸다. <br/>
이는 light_rank 이므로 신호등 주기를 변경해주는 우선순위이다. <br/>
15ns 에서의 light_rank 가 정상적으로 rank_calculator 로부터 trafficLight 모듈로 5 순위가 전달해왔다는 것을 알 수 있다. <br/>

### 4-3-5. CHECK_ACCUM_DATA

<p style="margin: 20px 0;">
	<img width="40%" height="219" alt="CHECK_ACCUM_DATA Log Image" src="https://github.com/user-attachments/assets/418accaa-cf5d-441d-a71c-c9d1677343d2" />
</p>

&nbsp;CHECK_ACCUM_DATA 가 194445ns 에서 발생한다. <br/>
이는 다음날 accum_data1 과 accum_data2 에 main highway 에서의 교통량이 누적이 잘 됐는지를 나타낸다. <br/>

<p center="align" style="margin: 20px 0;">
	<img width="49%" alt="CHECK_ACCUM_DATA Waveform Image1" src="https://github.com/user-attachments/assets/ec1e91d2-7c9b-432f-86ec-cf316dbe9b2d" />
	<img width="49%" alt="CHECK_ACCUM_DATA Waveform Image2" src="https://github.com/user-attachments/assets/9e80f2de-c565-4c91-b306-2482d580dc93" />
</p>

&nbsp;위 두사진에서 accum_data1,2 의 값을 보면, 전날 3 시에 입력된 교통량은 1 이고, 다음날 3 시에 입력된 교통량은 3 이다. <br/>
이를 통해, accum_data 의 값은 4 를 나타낼 것이고 이는 테스트 벤치에서도 잘 보여준다. <br/>

## 5. Testbench Waveform
### 5-1. Traffic Input

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="Traffic Input Waveform Image" src="https://github.com/user-attachments/assets/bc82876a-8f9a-4b3c-9239-4708a25ae050" />
</p>

&nbsp;위의 변수는 country_traffic 으로 30 초마다 한번 country road 쪽에서 오는 교통량을 받는다. <br/>
아래 변수는 main_traffic 으로 한시간에 한번 main highway 의 교통량을 받는다. <br/>
파형을 확인하면 7200ns 뒤에 다음 시간의 교통량을 받는 것을 확인 할 수 있다. <br/>

### 5-2. Base Light Period

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="Base Light Period Waveform Image" src="https://github.com/user-attachments/assets/f8f4dda8-dcff-46d1-88bb-ae0eec815506" />
</p>

&nbsp;맨위의 변수는 해당 시간대의 순위이다. 
0 순위는 아직 테스트 벤치에 교통량이 입력되기 전이므로 메모리 1 의 누적교통량이 전부 0 이기 때문에 이 상황을 표현하기 위해 모든 시간대의 순위가 0 순위이다. <br/>
0 순위 일때는 main highway 의 파란불 주기와 country road 의 파란불 주기가 각각 기본 setting 되어있는 3 분, 1 분이다. <br/>
이는 테스트 벤치의 맨 처음의 상황이 traffic 에 따라 영향을 받지않았기 때문이다. <br/>
따라서 간격이 720ns 인 것을 볼 수 있다. <br/>

### 5-3. Country Road 데이터 축적 및 신호 강제 변경

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="Country Road Waveform image" src="https://github.com/user-attachments/assets/b70349cc-5606-40d7-83e8-58344bd3e910" />
</p>

&nbsp;먼저 country traffic 의 축적된 data 를 보면 country road 의 신호등이 맨아래 변수이다. <br/>
country road 가 초록불 일때는 country traffic 에 데이터가 축적되지 않고 빨간불 일때만 데이터가 축적 됨을 볼 수 있다. <br/>
그리고 traffic 이 쌓여서 30 을 넘게 되면 넘었다는 것을 알려주는 pulse 신호가 생성되고 country 의 traffic signal 이 바로 초록불로 바뀌게 된다. <br/>

### 5-4. Traffic Rank

<p center="align" style="margin: 20px 0;">
	<img width="49%" alt="Traffic Rank Waveform Image 1" src="https://github.com/user-attachments/assets/564bb0a9-7409-4261-81d3-ca9fc6a3eb2b" />
	<img width="49%" alt="Traffic Rank Waveform Image 2" src="https://github.com/user-attachments/assets/cf279caf-266f-4ec7-a54a-be75729ffe7a" />
</p>

&nbsp;맨아래 데이터 변수는 앞의 10 비트는 누적 교통량 뒤의 5 비트는 순위이다. <br/>
그림에는 누적 교통량을 decimal 로 적어 두었다. <br/>
누적교통량이 제일큰 20 시가 1 의 rank 를 갖고 누적교통량이 가장 작은 5 시와 23 시가 8 위의 rank 를 갖는 것을 확인 할 수 있다. <br/>

### 5-5. Light Period by Accumulated Traffic

<p center="align" style="margin: 20px 0;">
	<img width="49%" alt="LPbAT Waveform Image 1" src="https://github.com/user-attachments/assets/ece29f01-b7fb-4059-9717-8b4f4cce28f4" />
	<img width="49%" alt="LPbAT Waveform Image 2" src="https://github.com/user-attachments/assets/b278a550-c377-4407-bd6a-90cfde91406a" />
</p>

&nbsp;첫번째 그림은 1 위 traffic light 의 시간간격으로 1800ns 정도이고 두번째 그림은 7 위 traffic light 의 시간간격으로 750ns 정도이다. <br/>
이렇게 교통량에 따라서 순위가 결정되고 결정된 순위에 따라 main highway 에 얼마나 오래 초록불을 줄 것이냐가 결정되는 것을 확인할 수 있다. <br/>

## 6 . 결론

<p center="align" style="margin: 20px 0;">
	<img width="90%" alt="결론 Waveform Image 1" src="https://github.com/user-attachments/assets/9285302d-8fca-4ef1-b0d3-234b6da39503" />
</p>

&nbsp;위와같이 country highway 에 누적된 차량 대수가 30 이상이 넘어가면, country highway 에 초록불을 주는 것을 볼 수 있다. <br/>

<p center="align" style="margin: 20px 0;">
	<img width="49%" alt="결론 Waveform Image 2" src="https://github.com/user-attachments/assets/f610c063-c190-42d7-972a-372c0935d627" />
	<img width="49%" alt="결론 Waveform Image 3" src="https://github.com/user-attachments/assets/ad73c7bb-069f-4e6a-bf80-64cba55b1701" />
</p>

&nbsp;가장 아래의 파형은 신호등 주기를 변경해주는 교통량 우선순위이고, 그 위의 파형은 흘러가는 시간을 나타낸다. <br/>
[0]이 main hightway 의 초록불을 나타내는데, 이는 시간마다 우선순위가 주어질 때마다, 주기가 변함을 알 수 있다. <br/>

&nbsp;따라서, interface 와 assertion 을 활용한 4 가지 이상의 협업하는 시스템을 설계 해보았다. <br/>
이는 사거리 신호등 교통체제의 시스템으로 교통량을 누적하여 우선순위를 부여하여, 시간마다의 신호등 주기를 조절하여, 교통체제를 다소 원활하게 할 수 있을 것이라고 예상한다. <br/>



