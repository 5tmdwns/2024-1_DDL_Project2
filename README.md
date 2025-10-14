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
  	- [4-3-1. Memory Overflow](#4-3-1-Memory-Overflow) <br/>
	- [4-3-2. CHECK_PULSE, CHECK_FINAL_PULSE](#4-3-2-CHECK_PULSE-CHECK_FINAL_PULSE) <br/>
	- [4-3-3. CEHCK_CNT](#4-3-3-CHECK_CNT) <br/>
	- [4-3-4. CHECK_ACCUM_EQUAL, CHECK_RANK](#4-3-4-CHECK_ACCUM_EQUAL-CHECK_RANK) <br/>
	- [4-3-5. CHECK_ACCUM_DATA](#4-3-5-CHECK_ACCUM_DATA) <br/>
- [5. Testbench Waveform](#5-Testbench-Waveform) <br/>
  - [5-1. Traffic Inpu](#5-1-Traffic-Input) <br/>
  - [5-2. Base Light Period](#5-2-Base-Light-Period) <br/>
  - [5-3. Country Road 데이터 축적 및 신호 강제 변경](#5-3-Country-Road-데이터-축적-및-신호-강제-변경) <br/>
  - [5-4. Traffic Rank](#5-4-Traffic-Rank) <br/>
  - [5-5. Light Period by Accumulated Traffic](#5-5-Light-Period-by-Accumulated-Traffic) <br/>
- [6. 결론](#6-결론) <br/>

## 1. 프로젝트 주제 및 목표
&nbsp;본 프로젝트의 주제는 매 시간 마다 Main Highway의 실시간 교통량과 Country road에 정차되어있는 자동차 대수를 측정하여 이를 Memory1에 저장하여 Memory1에 저장 되어있는 누적교통량을 기반해서 탄력적으로 신호등의 주기를 조절하는 시스템을 구성하였습니다. <br/>
특히, 이번 프로젝트 에는 전체 신호등 시스템을 다수의 모듈로 나누고, 모듈들이 데이터 정보를 일방향으로 보내는 것이 아닌, 다른 모듈과 쌍방향으로 데이터를 주고 받는 것에 집중하여 설계를 진행하였습니다. <br/>
이때, 모듈간의 연결을 System Verilog의 Interface 기능을 이용해 각 모듈이, 그리고 합친 전체 신호등 시스템이 모두 잘 작동하는지 확인하였습니다. <br/>
또한, 이런 확인 및 검증과정에서 System Verilog의 Assertion 등을 활용해 다양한 입력 패턴을 이용해 Testbench를 작성해 시스템의 응답을 확인하였습니다. <br/>

## 2. 프로젝트 설계 및 구성
### 2-1. Circuit Diagram
<p align="center" style="margin: 20px 0;">
  <img width="90%" alt="Circuit Diagram" src="https://github.com/user-attachments/assets/dac83661-b667-426d-81ba-236f7f80f53c" />
</p>

### 2-2. System Description
&nbsp;해당 신호등 시스템은 총 다섯개의 system이 상호작용합니다. <br/>
다섯개의 시스템은 CLOCK, TRAFFICLIGHT, CONTROLLER, MEMORY, RANK_CALCULATOR로 구성됩니다. <br/>

<p align="center" style="margin: 20px 0;">
  <img width="90%" alt="Highway Image" src="https://github.com/user-attachments/assets/09e4ac0a-0f78-4d41-b25a-765b1f56c4fb" />
</p>

&nbsp;저희는 4거리를 모델링 하여서 4거리에 적용할 수 있는 신호등 시스템을 설계하였습니다. <br/>
기본적으로 저희가 모델링한 4거리는 Main Highway와 Country Road 2개의 도로가 교차 되어있습니다. <br/>
Main Highway는 고속도로의 개념으로 기본적으로 통행량이 많습니다. <br/>
Country Road는 Main Highway에 비하여 교통량이 적습니다. <br/>
따라서, Main Highway의 파란불의 주기는 Country Road의 파란불의 주기보다 더욱 짧게 설정하였습니다. <br/>

### 2-3. 각 System 역할
#### System 1. CLOCK
&nbsp;CLOCK은 CONTROLLER, MEMORY에 시각 정보를 주어서 우리가 설계한 전체 시스템의 기준이 되는 시각정보를 제공하여 줍니다. <br/>
따라서, CONTROLLER와 MEMORY는 디지털 시계에서 제공해준 시간을 기준으로 신호등에 현재 시간대의 누적 교통량에 해당하는 주기를 결정합니다. <br/>

#### System 2. TRAFFICLIGHT
&nbsp;저희가 설계한 전체 시스템은 Main Highway의 통행량과 Country Road에 정차되어 있는 자동차 대수를 기반으로 신호등의 주기가 결정됩니다. <br/>
이때 Main Highway의 교통량과 Country Road에 정차되어 있는 자동차의 대수는 신호등에 부착되어 있는 센서가 측정하여서 CONTROLLER에게 전달 시켜주도록 신호등을 모델링 하였다. <br/>
즉, 신호등에는 Main Highway의 교통량을 측정해주는 센서와 10초 동안 Country Road에 새로 정차하는 자동차 대수를 측정해주는 센서 2개가 존재합니다. <br/>

&nbsp;기본적으로 Testbench를 처음 시작할 때 MEMORY에 저장되어 있는 누적 교통량은 전부 0으로 초기화 되어있는 상태입니다. <br/>
따라서, 기본적으로 Setting 되어 있는 Main Highway의 Green Light의 주기는 3분이고 Country Road의 Green Light의 주기는 1분입니다. <br/>

&nbsp;이 상태에서 신호등은 신호등에 부착되어 있는 Main Highway의 교통량을 측정하는 센서를 통하여 Main Highway의 교통량을 측정합니다. <br/>
Main highway의 교통량을 측정하는 센서가 1시간 동안 Main highway의 현재 교통량을 측정하여서 1시간 동안 측정된 교통량이 얼마나 많은 지 그 정도를 0에서 4까지 나누어 총 5단계로 구분하여서 CONTROLLER에 전달하여 줍니다. <br/>

&nbsp;CONTROLLER에서 Main Highway의 교통량을 받으면 MEMORY과 RANK_CALCULATOR를 통해서 현재 시각이 하루 24시간 중에서 교통량이 몇 순위인지 계산하여서 신호등에게 전달하여 줍니다. <br/>
그러면, 신호등은 현재 시각에 맞는 누적 교통량이 하루 24시간 중에서 몇 위인지 전달받습니다. <br/>
그리고, 이 순위를 기반으로 Main Highway의 파란불 주기를 어떻게 할지 결정합니다. <br/>

&nbsp;신호등에 부착되어 있는 또 다른 센서는 Main Highway가 파란 불일 때 Country Road는 빨간 불이므로 신호등에 부착되어있는 센서는 10초 동안 Country Road에 새로 정차하는 자동차 대수를 셉니다. <br/>
Main highway의 파란 불 주기가 기본적으로 Country Road의 파란 불 주기보다 훨씬 길기 때문에 Country Road에 정차되어 있는 차량 대수가 많아질 때 도로가 막히는 현상을 해결해주기 위해서 이 기능을 추가했습니다. <br/>

&nbsp;Country Road에 정차되어 있는 차량 대수가 많아질 때 도로가 막히는 현상을 해결해주기 위해서 이 기능을 추가했습니다. <br/>

&nbsp;신호등에 부착되어 있는 센서가 Main Highway가 파란 불일 때 Country Road에 정차되어 있는 자동차 대수를 측정해서 CONTROLLER에 전달해 주면 CONTROLLER는 내부적으로 계산을 하여서 Country Road에 정차되어 있는 차량수가 일정 이상이 될 때 신호등에게 Pulse를 줍니다. <br/>
신호등은 이 Pulse를 받으면 몇 Clock 뒤에 Main Highway를 빨간 불로 만들고 Country Road를 파란불로 만들어서 Country Road에 정차되어 있는 자동차들을 통행하게 만들어 주어서 도로가 막히는 것을 방지할 수 있습니다. <br/>

#### System 3. CONTROLLER
&nbsp;CONTROLLER가 받는 입력은 총 3개입니다. <br/>
첫 번째 입력은 신호등에게서 받는 현재 교통량 정보이고 두 번째 입력은 신호등에게서 받는 10초동안 새로 Country Road에 정차하는 자동차 대수입니다. <br/>
마지막으로 세 번째 입력은 MEMORY에게서 받는 정보입니다. <br/>
세 번째 입력은 총 15비트로 구성되어 있고 앞의 10비트는 현재 디지털 시계에서 주는 시간에 해당하는 구간의 총 누적 교통량입니다. <br/>
이는 테스트 벤치가 시작 했을 때부터 현재까지 해당구간에서 측정된 교통량의 총합입니다. <br/>
그리고, 뒤의 5bit는 MEMORY에 누적된 교통량을 기반으로 현재 시각이 하루 24시간 중에서 교통량이 몇 위인지를 담고 있습니다. <br/>
CONTROLLER의 기능은 총 2 개로 다음과 같습니다. <br/>
첫번째 기능은 MEMORY가 주는 누적교통량과 신호등에서 주는 현재 교통량을 더한 후에, 이 값을 디지털 시계에서 주는 현재 시간 정보와 합쳐서 MEMORY에게 다시 전달하여 줍니다. <br/>
이 정보는 총 15bit로 왼쪽 5bit는 디지털 시계에서 주는 시간 정보를 저장하고 있고, 오른쪽 10bit는 현재 시각에 해당하는 계산된 누적교통량입니다. <br/>
이 기능을 그림으로 나타내면 다음과 같습니다. <br/>

<p align="center" style="margin: 20px 0;">
  <img width="90%" alt="Controller Image" src="https://github.com/user-attachments/assets/4180848d-a0d1-49ef-99c2-8df5ac1c0399" />
</p>

&nbsp;두번째 기능은 10초 동안 Country Road에 새로 정차하는 자동차 대수를 신호등에서 주면, CONTROLLER는 이 값들을 모두 더하여 Country Road에 정차되어 있는 차량이 30대가 넘으면 신호등에게 Pulse를 줍니다. <br/>
이 때, CONTROLLER는 Main Highway가 파란불 일 때만 Country Road에 정차되어 있는 차량의 수를 더합니다. <br/>
이렇게 하는 이유는, Main Highway가 빨간 불이 되면 Country Road는 파란불이 되어 Country Road에 정차 되어 있는 차들이 통행을 할 수 있기 때문입니다. <br/>

#### System 4. MEMORY

<p style="margin: 20px 0;">
  <img width="30%" alt="Memory1 Image" src="https://github.com/user-attachments/assets/80a66ed8-d673-4285-917d-f90060125a47" />
</p>

&nbsp;MEMORY는 CONTROLLER, CLOCK, RANK_CALCULATOR 3개에서 모두 입력을 받습니다. <br/>
CONTROLLER 부터는 누적 교통량을 받고, 디지털 시계로 부터는 현재 시간을 받고, RANK_CALCULATOR에서는 시간대별 누적 교통량의 순위를 받습니다. <br/>

&nbsp;그리고, MEMORY는 각각의 모듈로 부터 받은 정보를 24개의 시간의 구간별로 누적 교통량과 순위정보를 갱신합니다. <br/>

#### System 5. RANK_CALCULATOR

<p style="margin: 20px 0;">
  <img width="30%" alt="Rank_cal Image" src="https://github.com/user-attachments/assets/daf162c2-07cd-4378-9257-3a4f8c8fe4d9" />
</p>

&nbsp;RANK_CALCULATOR 시스템은 MEMORY로 부터 입력 15bit를 받습니다. <br/>
이때 RANK_CALCULATOR의 입력으로 들어오는 15bit의 왼쪽 5bit는 시간 정보이고, 오른쪽 10bit는 누적교통량 정보입니다. <br/>
그러면 RANK_CALCULATOR는 위와 같이 구성된 15bit를 받으면, 해당 시각에 누적 교통량이 몇 위인지 시간에 따라 순위를 내림차순 정렬을 해줍니다. <br/>

## 3. 각 System 설명
### System 1. CLOCK

<p align="center" style="margin: 20px 0;">
  <img width="90%" alt="CLOCK Schematic" src="https://github.com/user-attachments/assets/7e2a6bd6-77ea-4219-9bc2-fe27b33bcc69" />
</p>

&nbsp;<strong>전용면적: 5859.13 (sq um)</strong> <br/>

&nbsp;CLOCK 모듈은 시간 값을 출력합니다. <br/>
CLK를 받아서 시간을 생성하고, 각 모듈에 시간 값을 뿌려줍니다. <br/>
다른 모듈들은 그 시간 값을 참고하여 값을 저장하거나, Traffic을 통제합니다. <br/>

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

&nbsp;이 블록은 CLK을 통해서 SECOND를 생성하는 부분입니다. <br/>
S_CLK 신호는 다음 신호인 MINUTE 신호를 동기화 시키는데 사용됩니다. <br/>
S_CLK 신호가 1부터 시작하면서 30초후 0으로 바뀌고 다시 30초후 1로 바뀝니다. <br/>
이때, 0에서 1로 바뀌는 신호는 MINUTE Block의 동기화 신호로 아래와 같이 들어갑니다. <br/>


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

&nbsp;이 블록도 SECOND 블록과 마찬가지입니다. <br/>
M_CLK이 시간을 생성하는 블록의 동기화 신호가 됩니다. <br/>

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

&nbsp;CLK(Input) : 클럭 입력신호로 이 모듈의 동기신호입니다. <br/>
SECOND, MINUTE, HOUR(Output) : 시간, 분, 초의 각각의 Output 입니다. <br/>

### System 2. TRAFFICLIGHT

<p align="center" style="margin: 20px 0;">
  <img width="90%" alt="TRAFFICLIGHT Schematic" src="https://github.com/user-attachments/assets/1a84d8fc-e231-4a68-be32-908b0f1dff72" />
</p>

&nbsp;<strong>전용면적: 7797 (sq um)</strong>

``` systemverilog
module TRAFFICLIGHT(SYSTEM_BUS.TRAFFIC_LIGHT i2);

   typedef enum logic [1:0] {RED = 2'b00, GREEN, YELLOW} LIGHTSTATE;
   enum logic [1:0] {S0 = 2'b00, S1, S2, S3} STATE;
   logic PREV_PULSE, FINAL_PULSE, MAIN_CNT_ENABLE, CNTRY_CNT_ENABLE = 1'b0;
   logic [8:0] CNT = 0;

   LIGHTSTATE MAINLIGHT = GREEN;
   LIGHTSTATE CNTRYLIGHT = RED;
...
```

&nbsp;내부에서 사용하는 Logic은 다음과 같습니다. <br/>

- typedef enum logic [1:0] {RED = 2’b00, GREEN, YELLO} LIGHTSTATE : FSM 을 쉽게 사용하기 위한 열거형 type 선언. <br/>
- enum logic [2:0] {S0 = 2’b00, S1, S2, S3} STATE : state 는 FSM 을 이용하여 main highway 와 country highway 의 신호등을 결정. <br/>
- PREV_PULSE : CONTROLLER에서 받아오는 펄스를 저장. <br/>
- FINAL_PULSE : PREV_PULSE를 이용하여 1을 띄우게 함. <br/>
- MAIN_CNT_ENABLE : Main Highway의 초록불의 주기를 Clock에 따라 Count 하기 위해 필요한 신호. <br/>
- CNTRY_CNT_ENABLE : Country Highway의 초록불의 주기를 Clock에 따라 Count 하기 위해 필요한 신호. <br/>

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

&nbsp;구동원리 : FSM을 이용하여, State별로 동작하게 합니다. <br/>

&nbsp;S0 (main : GREEN, country : RED) <br/>
MAIN_CNT_ENALBE 동작 -> Main Highway의 초록불 -> CNT의 카운터 기능 활성화 -> Inside를 이용하여 우선순위를 받을시, 받아온 우선 순위를 이용하여 CNT가 730 - (40 * 우선순위)가 넘어갈시 S1으로 이동. <br/>
그렇지 않다면, 신호등 기본 주기인 360 Clock 뒤에 S1으로 이동하도록 설계. <br/>

&nbsp;S1 (main : YELLOW, country : RED) <br/>
Main Highway의 노란불 -> 다음 클락에 S2로 이동하도록 설계. <br/>

&nbsp;S2 (main : RED, country : GREEN) <br/>
CNTRY_CNT_ENABLE 동작 -> Country Highway의 초록불 -> CNT의 카운터 기능 활성화 -> 단, FINAL_PULSE가 있을 시, Country Highway의 차량이 30대 이상이므로 Country Highway의 GREEN 주기를 240 Clock으로 늘려줌. <br/>
그렇지 않다면, 신호등 기본 주기인 120 Clock 뒤에 S3로 이동하도록 설계. <br/>

&nbsp;S3 (main : RED, country : YELLOW) <br/>
Country Highway의 노란불 -> 다음 클락에 S0로 이동하도록 설계. <br/>

&nbsp;이처럼, FSM을 이용하여 간단한 신호등 모듈을 만들고, 외부적 요소들은 조건문을 추가하여 설계하였습니다. <br/>

&nbsp;- CONTROLLER의 (0 -> 1 -> 0) Pulse를 1의 신호로 변경하기 : PREV_PULSE에 CONTROLLER에서 주는 Pulse(1)를 저장한 뒤, 현 Clock에서의 PREV_PULSE == 0, 다음 Clock에서 PREV_PULSE == 1 이 되는 것을 이용하여, FINAL_PULSE를 1로 변경. <br/>

### System 3. CONTROLLER

<p align="center" style="margin: 20px 0;">
  <img width="90%" alt="CONTROLLER Schematic" src="https://github.com/user-attachments/assets/53c4ec59-86e8-4042-956c-8d0788d1f56c" />
</p>

&nbsp;<strong>전용면적: 8653.63 (sq um)</strong>

&nbsp;CONTROLLER 모듈은 교차 도로와 메인 도로의 신호 상태와 교통량을 관리하며, 특정 조건에서 신호 제어 펄스를 생성합니다. <br/>
교차 도로의 누적 차량 수를 계산하고, 교통량 변화에 따라 메모리 작업 상태를 설정합니다. <br/>
또한, 누적 교통량 데이터를 기반으로 신호등 순위를 결정합니다. <br/>

``` systemverilog
module CONTROLLER (SYSTEM_BUS.CONTROLLER i1);

   logic [6:0] COUNTRY_CAR_NUMBER = 0;
   bit [2:0] PREV_COUNTRY_CAR_NUM, PREV_CURRENT_TRAFFIC_AMOUNT;
   MEM_OP OP;
...
```

&nbsp;- COUNTRY_CAR_NUMBER: 이 신호는 교차 도로의 누적 차량 수를 저장하는 역할을 합니다. 교차 도로의 차량 수가 업데이트될 때마다 증가하며, 일정 수치(예: 30)를 초과할 경우 신호 제어 펄스를 활성화합니다. 7비트로 구성되어 있으며, 초기값은 0으로 설정됩니다. <br/>

&nbsp;- PREV_COUNTRY_CAR_NUM: 이 신호는 이전 클럭 사이클에서의 교차 도로 차량 수를 저장합니다. 현재 교차 도로 차량 수와 비교하여 변화가 있는지 확인하는 데 사용됩니다. 3비트로 구성되어 있습니다. <br/>

&nbsp;- PREV_CURRENT_TRAFFIC_AMOUNT: 이 신호는 이전 클럭 사이클에서의 메인 도로의 현재 교통량을 저장합니다. 현재 교통량과 비교하여 변화가 있는지 확인하는 데 사용됩니다. 3비트로 구성되어 있습니다. <br/>


``` systemverilog
...
   always_ff @(posedge i1.CLK) begin
      PREV_COUNTRY_CAR_NUM <= i1.COUNTRY_CAR_NUM;
      PREV_CURRENT_TRAFFIC_AMOUNT <= i1.CURRENT_TRAFFIC_AMOUNT;
   end
...
```

&nbsp;이 블록은 교차 도로의 차량 수와 메인 도로의 교통량을 업데이트하는 역할을 합니다. <br/>
이전 값을 현재 값으로 저장하여 다음 클럭 사이클에서 비교할 수 있도록 합니다. <br/>

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

&nbsp;이 블록은 교차 도로의 차량 수를 관리하고, 메인도로의 신호 상태에 따라 교차 도로 신호 제어 펄스를 생성합니다. <br/>

&nbsp;COUNTRY_CAR_NUMBER가 PREV_COUNTRY_CAR_NUM과 다를 경우, 즉 교차 도로의 차량 수가 변화한 경우에 실행됩니다. <br/>
예를들어, 메인도로 신호가 녹색(light[0] == 1)일 때 누적 차량 수(COUNTRY_CAR_NUMBER)에 현재 차량 수(COUNTRY_CAR_NUM)를 더합니다. <br/>
누적 차량 수가 30을 초과하면, 신호 제어 펄스(COUNTRY_PULSE)를 활성화(1)하고, 누적 차량 수를 초기화합니다. <br/>

&nbsp;그렇지 않으면, 신호 제어 펄스를 비활성화(0)합니다. <br/>
메인도로 신호가 녹색이 아닌 경우(light[0] == 0) 누적 차량 수와 신호 제어 펄스를 초기화합니다. <br/>
교차 도로의 차량 수가 이전 값과 동일한 경우 신호 제어 펄스를 비활성화합니다. <br/>

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

&nbsp;이 블록은 현재 교통량을 관리하고, 메모리 작업 상태를 설정하며, 누적 교통량 데이터를 계산합니다. <br/>

&nbsp;CURRENT_TRAFFIC_AMOUNT 가 PREV_CURRENT_TRAFFIC_AMOUNT와 다를 경우, 즉 현재 교통량이 변화한 경우에 실행됩니다. <br/>
현재 교통량이 이전 값과 다른 경우 메모리 작업 상태(OP)를 쓰기(WRITE)로 설정합니다. <br/>
현재 시간(HOUR)을 누적 데이터(ACCUM_DATA1)의 상위 5비트에 저장합니다. <br/>
현재 교통량(CURRENT_TRAFFIC_AMOUNT)과 이전에 누적된 교통량(ACCUM_DATA2의 상위 10비트)을 더해 누적 데이터(ACCUM_DATA1)의 하위 10비트에 저장합니다. <br/>

&nbsp;현재 교통량이 이전 값과 같은 경우 메모리 작업 상태(OP)를 읽기(READ)로 설정합니다. <br/>

### System 4. MEMORY

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="MEMORY Schematic" src="https://github.com/user-attachments/assets/0345ca4f-2463-46a6-80ba-f28a7566c457" />
</p>

&nbsp;<strong>전용면적: 212382.00 (sq um)</strong>

&nbsp;MEMORY 모듈은 시간대별로 교통량과 순위 데이터를 저장하고 업데이트하는 역할을 합니다. <br/>
이 모듈은 컨트롤러로부터 받은 교통량 정보를 특정 시간대에 저장하며, RANK_CALCULATOR로부터 받은 순위 데이터를 기반으로 교통량 순위를 업데이트합니다. <br/>
저장된 데이터는 다른 모듈로 전송되어 교통 상태를 관리하는 데 사용됩니다. <br/>
또한, 현재 시간대의 교통량과 순위 데이터를 컨트롤러에 제공합니다. <br/>

``` systemverilog
module MEMORY (SYSTEM_BUS.MEM i3);

   bit [19:0] MEMORY[23:0];
   bit [4:0]		i;
...
```

&nbsp;- MEMORY 배열 (bit [19:0] MEMORY[23:0]): 이 배열은 24개의 20비트 데이터를 저장하는 메모리입니다. 각 시간대별로 데이터를 저장할 수 있도록 설계되었습니다. 상위 5비트는 시간 정보, 중간 10비트는 교통량 정보, 마지막 하위 5비트는 교통량 순위 정보를 담고 있습니다. <br/>

&nbsp;- 반복문 인덱스 (bit [4:0] i): i는 for 루프에서 사용되는 반복문 인덱스입니다. 메모리와 데이터 배열을 순회하며 데이터를 읽거나 쓸 때 사용됩니다. bit[4:0]은 5비트 크기의 인덱스를 의미합니다. 5비트는 0부터 31까지의 값을 표현할 수 있으므로, 24개의 데이터 인덱스를 순회하는 데 충분하게 사용할 수 있습니다. <br/>

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

&nbsp;always_ff 블록은 클럭 신호 (CLK)의 상승 에지에서 동작합니다. <br/>
이 블록은 주어진 연산 명령 (OP1 및 OP2)에 따라 메모리 읽기 및 쓰기 작업을 수행하며 누적 교통량 데이터와 교통량 순위 데이터를 관리합니다. <br/>

&nbsp;- WRITE 동작 (OP1이 WRITE 일 때) <br/>
OP1이 WRITE인 경우, 현재 시간 (HOUR)에 해당하는 메모리 위치에 누적 교통량 데이터 (ACCUM_DATA1[14:0])를 저장합니다. <br/>
메모리의 상위 15비트([19:5])에 저장됩니다. <br/>
모든 시간대에 대해 누적 교통량 데이터를 TRAFFIC_DATA 배열에 갱신합니다. <br/>
메모리의 상위 15비트([19:5])를 TRAFFIC_DATA의 각 시간대 위치에 복사합니다. <br/>

&nbsp;- WRITE 동작 (OP2가 WRITE 일 때) <br/>
OP2가 WRITE인 경우, 모든 시간대에 대해 교통량 순위 데이터를 메모리에 갱신합니다. <br/>
각 시간대의 교통량 순위 데이터(TRAFFIC_RANKED_DATA[i][4:0])를 메모리의 하위 5비트([4:0])에 저장합니다. <br/>
현재 시간(HOUR)에 해당하는 메모리 위치에서 누적 교통량과 순위 데이터를 읽어와서 ACCUM_DATA2에 저장합니다. <br/>

&nbsp;- 기본 동작 (READ 동작) <br/>
기본 동작으로 OP1이 READ 일 때와 유사하게 현재 시간(HOUR)에 해당하는 메모리 위치에 누적 교통량 데이터를 저장하고(ACCUM_DATA1[14:0]), 그 위치에서 누적 교통량과 순위 데이터를 읽어와서 ACCUM_DATA2에 저장합니다. <br/>

&nbsp;MEMORY는 위와 같은 로직에 의해서 입력된 데이터를 메모리에 저장하고, 저장된 데이터를 출력 포트로 제공합니다. <br/>
따라서, 외부에 의해 연산 명령이 주어지면 메모리의 읽기 및 쓰기 작업을 수행할 수 있습니다. <br/>

### System 5. RANK_CALCULATOR

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="RANK_CALCULATOR Schematic" src="https://github.com/user-attachments/assets/92a25f97-47a5-495f-89c4-9f8aee886155" />
</p>

&nbsp;<strong>전용면적: 416855.56 (sq um)</strong>

&nbsp;RANK_CALCULATOR 모듈은 MEMORY로부터 받은 시각, 교통량의 정보를 교통량의 순서대로 정렬해 출력으로 현재 시각과 해당하는 순위른 다시 MEMORY에 보냅니다. <br/>
순위는 1부터 24로 나타나며, 입력이 들어오지 않은 시각대에서 순위를 0으로 보냅니다. <br/>

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

&nbsp;들어온 24개 시각에 대해 우선 출력으로 나가는 순위 정보를 모두 0으로 초기화 합니다. <br/>
다음으로, 반복문을 사용하여 하나의 Input의 교통량을 다른 모든 23개의 Input의 교통량과 비교합니다. <br/>
만약, 교통량이 적다면 순위는 하나씩 더해져 뒤로 밀려납니다. <br/>
만약, 같은 순위가 2개 나오다면 다음 중복되는 수만큼 순위가 뒤로 밀려납니다.(ex. 1 2 3 3 3 6 위 …) <br/>

``` systemverilog
...
		for (i = 0; i < 24; i ++) begin
			if (INPUT_DATA[i][9:0] >= 10'b00000_00000) begin
				RANK[i] = RANK[i] + 1;
			end
		end
...
```

&nbsp;위 코드에서 순위의 초기값을 0으로 설정했기에 순위를 모두 1을 더해줘, 1부터 시작하게 만듭니다. <br/>
대신 Input이 들어온 경우만 한해서 순위가 개선되고 입력이 들어오지 않은 시간대에는 순위가 여전히 0이 나타나게 됩니다. <br/>

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

&nbsp;MEMORY에게 다시 데이터를 보내주기 위해서 10bit 정보를 구성합니다. <br/>
상위 5bit에는 입력에 해당하는 현재 시각 정보가, 하위 5bit에는 내부 Logic으로 저장된 Rank 값이 할당 됩니다. <br/>
따라서, 입력이 존재한다면 현재 시각과 그에 해당하는 교통량의 순위가 10bit로 구성되 출력으로 나옵니다. <br/>
입력이 없는 경우, Rank에 내부 Logic으로 0이 저장되어 있기 때문에 입력으로 들어오지 않은 시각의 순위는 0으로 출력이 나타납니다. <br/>

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

&nbsp;위 신호등 시스템에서 Interface를 통해서 연결한 것을 확인하면, 신호등 내부에 수많은 데이터 정보의 흐름이 존재하지만, 우리가 관심있는 영역에 대해서 Interface를 통해 묶고 나머지는 내부 변수로 처리했음을 알 수 있습니다. <br/>

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

&nbsp;System Verilog의 Modport는 Interface의 특정 신호에 대한 접근 권한을 정의하는데 사용되며, 이를 통해 인터페이스를 사용하는 모듈의 역할에 따라 신호의 입출력 방향을 명확히 설정할 수 있습니다. <br/>

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

&nbsp;Randomize를 License가 없어 사용할 수 없기 때문에, 임의로 Randomize하게 보이는 Testbench를 구현했습니다. <br/>
이 System에서는 2ns를 1초라고 정의하였습니다. <br/>
120까지 도는 for문 2개를 이용했는데 중첩하여 이용했습니다. <br/>
내부 for문에 60의 Delay를 주어서 7200ns 즉 1시간을 120번 돌아서 5일동안 동작하게 구현하였습니다. <br/>
그리고 Main 교통량을 구현할 때, 이전 교통량을 저장해두고 해당인덱스를 더하고 5로 나누어서 0~4까지로 교통량을 수치화하였습니다. <br/>
이전 교통량에 인덱스를 더하고 나누어 주면서, Testbench를 실행했을때 무작위 처럼 보이는 교통량 입력을 주었습니다. <br/>

### 4-3. Assertion(Immediate, Not Concurrent)

&nbsp;Sequential Logic을 사용한 시스템으로서, Concurrent Assertions을 사용해야 하지만, License 문제로 인해 Immediate Assertions을 사용해야만 했습니다. <br/>
이는, Combinational Logic을 위한 검증으로 본 시스템에는 다소 맞지 않습니다. <br/>

&nbsp;아래는, 각 모듈에서 중요한 신호나 Logic을 위한 <span style="color:red">6 가지의 Assertion</span> 입니다. <br/>
각각의 시스템은 이와같이 동작할 것을 암시합니다. <br/>

&nbsp;<strong><u>저희가 설계한 시스템은 아래와 같이 많은 Assertion을 이용함으로써, 스마트한 검증이라는 설계 스펙에 최대한 부합하게 설계하였습니다.</strong></u> <br/>

&nbsp;CONTROLLER : CHECK_PULSE, CHECK_ACCUM_DATA <br/>
&nbsp;TRAFFICLIGHT : CHECK_FINAL_PULSE, CHECK_CNT <br/>
&nbsp;MEMORY : CHECK_ACCUM_EQUAL <br/>
&nbsp;RANK_CALCULATOR : CHECK_RANK <br/>

#### 4-3-1. Memory Overflow

<p align="center" style="margin: 20px 0;">
	<img width="49%" alt="Memory Overflow Code Image1" src="https://github.com/user-attachments/assets/c5d2db38-c54b-44b2-b9ff-70c2714ee983" />
	<img width="49%" alt="Memory Overflow Code Image2" src="https://github.com/user-attachments/assets/2f569fbe-8f99-4d76-a138-f0e1162e9b33" />
</p>

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="Memory Overflow Log Image" src="https://github.com/user-attachments/assets/e2e3a9a5-7ae9-40f9-b09e-361ea9fefaf4" />
</p>

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="Memory Overflow Waveform Image" src="https://github.com/user-attachments/assets/38fad131-5f5f-489c-b541-03eb9200a949" />
</p>

&nbsp;첫 번째 사진은 CONTROLLER 모듈의 일부입니다. <br/>
CONTROLLER는 메모리가 CONTROLLER에게 주는 정보인 accum_data2와 현재 Main Highway의 Traffic 정보인 current_traffic_amount를 덧셈 연산하여 accum_data1에 전달해 줍니다. <br/>
이때 60~61번째 줄을 확인하면 Assert 구문의 활용을 볼 수 있습니다. <br/>
해당 Assert 구문은 교통량 정보를 축적하여 저장하는 메모리가 오버플로우 나는 경우를 탐지합니다. <br/>
테스트 벤치에서 강제로 current_traffic_amount와 연결된 mainToCtrl 에 10’b1111111111 의 값을 넣어 주었고 Fatal에 의해서 정지되었습니다. <br/>
파형과 로그 확인 결과, 세번째 사진의 62 번째 줄에 로그가 떠있는 것을 확인 할 수 있고, 시뮬레이션 파형에서도 멈춘것을 확인 할 수 있습니다. <br/>

#### 4-3-2. CHECK_PULSE, CHECK_FINAL_PULSE

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="CHECK_PULSE, CHECK_FINAL_PULSE Log Image" src="https://github.com/user-attachments/assets/37b6f0a6-3dbd-4659-bda7-ae0807eafbac" />
</p>

&nbsp;위의 Time은 1ns의 기준입니다. <br/>
사진과 같이 CHECK_PULSE FAIL이 45ns, CHECK_FINAL_PULSE FAIL이 47ns에서 발생합니다. <br/>
이는, Concurrent Assertion으로 검증을 해야한다. <br/>

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="CHECK_PULSE, CHECK_FINAL_PULSE Waveform Image" src="https://github.com/user-attachments/assets/7bec4023-369c-4a53-bf59-851a4f3124a2" />
</p>

&nbsp;Country Road의 누적 차량 대수가 30 이상 됐을 시, Pulse가 발생하는 것을 알 수 있습니다. <br/>
Pulse가 발생하고 다음 클락에 finalPulse가 발생하게 되는데 선언한 Assertion은 클락의 기준이 아니므로, FAIL이 뜰 수도 있고 PASS가 뜰 수도 있습니다. <br/>

#### 4-3-3. CHECK_CNT

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="CEHCK_CNT Log Image" src="https://github.com/user-attachments/assets/16cd5ed6-ff07-4d95-b74c-1f8805828996" />
</p>

&nbsp;1269ns에서 CNT PASS가 발생합니다. <br/> 
이는 신호등의 주기를 세어주는 cnt 값이 360 이상이 되었다는 뜻 입니다. <br/>

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="CHECK_CNT Waveform Image" src="https://github.com/user-attachments/assets/4bcf8291-849e-4fd2-9ff2-7f24d11427fb" />
</p>

&nbsp;다음과 같은 사진을 보면, Main Highway의 신호등이 파란불이 되는 시기부터 1269ns까지는 신호등의 초록불 주기가 기본주기인 것 입니다. <br/>
이는 우선순위 light_rank를 trafficLight 모듈이 받았으므로, 기본주기보다 훨씬 더 길어진 것 입니다. <br/>

#### 4-3-4. CHECK_ACCUM_EQUAL, CHECK_RANK

<p style="margin: 20px 0;">
	<img width="40%" alt="CHECK_ACCUM_EQUAL, CHECK_RANK Log Image" src="https://github.com/user-attachments/assets/cf869d6d-2f70-4d2d-bbe0-a8da6756c360" />
</p>

&nbsp;위의 사진을 보면, CHECK_RANK PASS가 9ns에서 발생하고, CHECK_RANK PASS가 11ns에서 발생하는 것을 알 수 있습니다. <br/>

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="CHECK_ACCUM_EQUAL, CHECK_RANK Waveform Image1" src="https://github.com/user-attachments/assets/91c70790-3b24-4bbc-95d7-f283bfdca544" />
</p>

&nbsp;9ns에서의 accum_data1[9:0]과 accum_data2[14:5]의 누적 교통량 수가 같아짐을 알 수 있습니다. <br/>
이는 memory와 rank_calculator 모듈이 정상 동작을 한다는 것을 알 수 있습니다. <br/>

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="CHECK_ACCUM_EQUAL, CHECK_RANK Waveform Image2" src="https://github.com/user-attachments/assets/84d936e4-dea5-4fa8-9d29-960b6b641a42" />
</p>

&nbsp;op1 == read 상태일 때, traffic_ranked_data[i4.hour][4:0]를 내보내는지를 나타냅니다. <br/>
이는 light_rank 이므로 신호등 주기를 변경해주는 우선순위 입니다. <br/>
15ns에서의 light_rank가 정상적으로 rank_calculator로부터 trafficLight 모듈로 5 순위가 전달해왔다는 것을 알 수 있습니다. <br/>

#### 4-3-5. CHECK_ACCUM_DATA

<p style="margin: 20px 0;">
	<img width="40%" height="219" alt="CHECK_ACCUM_DATA Log Image" src="https://github.com/user-attachments/assets/418accaa-cf5d-441d-a71c-c9d1677343d2" />
</p>

&nbsp;CHECK_ACCUM_DATA가 194445ns에서 발생합니다. <br/>
이는 다음날 accum_data1과 accum_data2에 Main Highway에서의 교통량이 누적이 잘 됐는지를 나타냅니다. <br/>

<p align="center" style="margin: 20px 0;">
	<img width="49%" alt="CHECK_ACCUM_DATA Waveform Image1" src="https://github.com/user-attachments/assets/ec1e91d2-7c9b-432f-86ec-cf316dbe9b2d" />
	<img width="49%" alt="CHECK_ACCUM_DATA Waveform Image2" src="https://github.com/user-attachments/assets/9e80f2de-c565-4c91-b306-2482d580dc93" />
</p>

&nbsp;위 두사진에서 accum_data1,2의 값을 보면, 전날 3시에 입력된 교통량은 1이고, 다음날 3시에 입력된 교통량은 3입니다. <br/>
이를 통해, accum_data의 값은 4를 나타낼 것이고, 이는 테스트 벤치에서도 잘 보여줍니다. <br/>

## 5. Testbench Waveform
### 5-1. Traffic Input

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="Traffic Input Waveform Image" src="https://github.com/user-attachments/assets/bc82876a-8f9a-4b3c-9239-4708a25ae050" />
</p>

&nbsp;위의 변수는 country_traffic으로 30초마다 한번 country road 쪽에서 오는 교통량을 받습니다. <br/>
아래 변수는 main_traffic으로 한시간에 한번 main highway의 교통량을 받습니다. <br/>
파형을 확인하면, 7200ns 뒤에 다음 시간의 교통량을 받는 것을 확인 할 수 있습니다. <br/>

### 5-2. Base Light Period

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="Base Light Period Waveform Image" src="https://github.com/user-attachments/assets/f8f4dda8-dcff-46d1-88bb-ae0eec815506" />
</p>

&nbsp;맨위의 변수는 해당 시간대의 순위입니다. 
0순위는 아직 테스트 벤치에 교통량이 입력되기 전이므로, 메모리 1의 누적교통량이 전부 0이기 때문에, 이 상황을 표현하기 위해 모든 시간대의 순위가 0순위 입니다. <br/>
0순위 일때는 Main Highway의 파란불 주기와 Country Road의 파란불 주기가 각각 기본 Setting 되어있는 3분, 1분입니다. <br/>
이는 테스트 벤치의 맨 처음의 상황이 Traffic에 따라 영향을 받지않았기 때문입니다. <br/>
따라서, 간격이 720ns 인 것을 볼 수 있습니다. <br/>

### 5-3. Country Road 데이터 축적 및 신호 강제 변경

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="Country Road Waveform image" src="https://github.com/user-attachments/assets/b70349cc-5606-40d7-83e8-58344bd3e910" />
</p>

&nbsp;먼저 Country Traffic의 축적된 Data를 보면 Country Road의 신호등이 맨아래 변수입니다. <br/>
Country Road가 초록불 일때는 Country Traffic에 데이터가 축적되지 않고 빨간불 일때만 데이터가 축적 됨을 볼 수 있습니다. <br/>
그리고 Traffic이 쌓여서 30을 넘게 되면, 넘었다는 것을 알려주는 Pulse신호가 생성되고, Country의 Traffic Signal이 바로 초록불로 바뀌게 됩니다. <br/>

### 5-4. Traffic Rank

<p align="center" style="margin: 20px 0;">
	<img width="49%" alt="Traffic Rank Waveform Image 1" src="https://github.com/user-attachments/assets/564bb0a9-7409-4261-81d3-ca9fc6a3eb2b" />
	<img width="49%" alt="Traffic Rank Waveform Image 2" src="https://github.com/user-attachments/assets/cf279caf-266f-4ec7-a54a-be75729ffe7a" />
</p>

&nbsp;맨아래 데이터 변수는 앞의 10비트는 누적 교통량 뒤의 5비트는 순위입니다. <br/>
그림에는 누적 교통량을 Decimal로 적어 두었습니다. <br/>
누적교통량이 제일큰 20시가 1의 Rank를 갖고, 누적교통량이 가장 작은 5시와 23시가 8위의 Rank를 갖는 것을 확인 할 수 있습니다. <br/>

### 5-5. Light Period by Accumulated Traffic

<p align="center" style="margin: 20px 0;">
	<img width="49%" alt="LPbAT Waveform Image 1" src="https://github.com/user-attachments/assets/ece29f01-b7fb-4059-9717-8b4f4cce28f4" />
	<img width="49%" alt="LPbAT Waveform Image 2" src="https://github.com/user-attachments/assets/b278a550-c377-4407-bd6a-90cfde91406a" />
</p>

&nbsp;첫번째 그림은 1위 Traffic Light의 시간간격으로 1800ns 정도이고, 두번째 그림은 7위 Traffic Light의 시간간격으로 750ns 정도입니다. <br/>
이렇게 교통량에 따라서 순위가 결정되고, 결정된 순위에 따라 Main Highway에 얼마나 오래 초록불을 줄 것이냐가 결정되는 것을 확인할 수 있습니다. <br/>

## 6. 결론

<p align="center" style="margin: 20px 0;">
	<img width="90%" alt="결론 Waveform Image 1" src="https://github.com/user-attachments/assets/9285302d-8fca-4ef1-b0d3-234b6da39503" />
</p>

&nbsp;위와같이 Country Highway에 누적된 차량 대수가 30이상이 넘어가면, Country Highway에 초록불을 주는 것을 볼 수 있습니다. <br/>

<p align="center" style="margin: 20px 0;">
	<img width="49%" alt="결론 Waveform Image 2" src="https://github.com/user-attachments/assets/f610c063-c190-42d7-972a-372c0935d627" />
	<img width="49%" alt="결론 Waveform Image 3" src="https://github.com/user-attachments/assets/ad73c7bb-069f-4e6a-bf80-64cba55b1701" />
</p>

&nbsp;가장 아래의 파형은 신호등 주기를 변경해주는 교통량 우선순위이고, 그 위의 파형은 흘러가는 시간을 나타냅니다. <br/>
[0]이 Main Hightway의 초록불을 나타내는데, 이는 시간마다 우선순위가 주어질 때마다, 주기가 변함을 알 수 있습니다. <br/>

&nbsp;따라서, Interface와 Assertion을 활용한 4 가지 이상의 협업하는 시스템을 설계를 해보았습니다. <br/>
이는 사거리 신호등 교통체제의 시스템으로 교통량을 누적하여 우선순위를 부여하며, 시간마다의 신호등 주기를 조절하여, 교통체제를 다소 원활하게 할 수 있을 것이라고 예상합니다. <br/>



