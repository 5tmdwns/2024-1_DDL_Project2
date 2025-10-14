<p align="center">
  <h1 align="center">실시간 교통량을 기반으로 한 교차로 신호등 Controller✨</h1>
  <p align="center">
    <img width="90%" alt="Simulation Full Screen" src="https://github.com/user-attachments/assets/4a4d7587-af02-4c5b-8604-4b835c97bd37" />
  </p>
</p>

## Index ⭐️
- [1. 프로젝트 주제 및 목표](#프로젝트-주제-및-목표) <br/>
- [2. 프로젝트 설계 및 구성](#프로젝트-설계-및-구성) <br/>
  - [2-1. Circuit Diagram](#Circuit-Diagram) <br/>
  - [2-2. System Description](#System-Description) <br/>
  - [2-3. 각 System 역할](#각-System-역할) <br/>
- [3. 각 System 설명](#각-System-설명) <br/>
- [4. Module Verification](#Module-Verification) <br/>
- [5. Testbench Waveform](#Testbench-Waveform) <br/>
- [6. 결론](#결론) <br/>

## 프로젝트 주제 및 목표
&nbsp;본 프로젝트의 주제는 매 시간 마다 Main Highway 의 실시간 교통량과 Country road 에 정차되어있는 자동차 대수를 측정하여 이를 Memory1 에 저장하여 Memory1 에 저장 되어있는 누적교통량을 기반해서 탄력적으로 신호등의 주기를 조절하는 시스템을 구성하였습니다. <br/>
특히, 이번 프로젝트 에는 전체 신호등 시스템을 다수의 모듈로 나누고, 모듈들이 데이터 정보를 일방향으로 보내는 것이 아닌, 다른 모듈과 쌍방향으로 데이터를 주고 받는 것에 집중하여 설계를 진행하였습니다. <br/>
이때, 모듈간의 연결을 System Verilog 의 Interface 기능을 이용해 각 모듈이, 그리고 합친 전체 신호등 시스템이 모두 잘 작동하는지 확인하였습니다. <br/>
또한, 이런 확인 및 검증과정에서 System Verilog 의 Assertion 등을 활용해 다양한 입력 패턴을 이용해 Test Bench 를 작성해 시스템의 응답을 확인하였습니다. <br/>

## 프로젝트 설계 및 구성
### Circuit Diagram
<p align="center" style="margin: 20px 0;">
  <img width="90%" alt="Circuit Diagram" src="https://github.com/user-attachments/assets/dac83661-b667-426d-81ba-236f7f80f53c" />
</p>

### System Description
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

### 각 System 역할
#### System 1. 디지털 시계
&nbsp;디지털 시계는 Controller, Memory에 시각 정보를 주어서 우리가 설계한 전체 시스템의 기준이 되는 시각정보를 제공하여 준다. <br/>
따라서 Controller 와 Memory 는 디지털 시계에서 제공해준 시간을 기준으로 신호등에 현재 시간대의 누적 교통량에 해당하는 주기를 결정한다. <br/>

#### System 2. 신호등
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

#### System 3. Controller
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

#### System 4. Memory1

<p style="margin: 20px 0;">
  <img width="30%" alt="Memory1 Image" src="https://github.com/user-attachments/assets/80a66ed8-d673-4285-917d-f90060125a47" />
</p>

&nbsp;memory1 은 controller, 디지털 시계, rank_cal 3 개에서 모두 입력을 받는다. <br/>
controller 로 부터는 누적 교통량을 받고 디지털 시계로 부터는 현재 시간을 받고 rank_cal 에서는 시간대별 누적 교통량의 순위를 받는다. <br/>

&nbsp;그리고 memory1 은 각각의 모듈로 부터 받은 정보를 24 개의 시간의 구간별로 누적 교통량과 순위정보를 갱신한다. <br/>

#### System 5. Rank_cal

<p style="margin: 20px 0;">
  <img width="30%" alt="Rank_cal Image" src="https://github.com/user-attachments/assets/daf162c2-07cd-4378-9257-3a4f8c8fe4d9" />
</p>

&nbsp;Rank_cal 시스템은 Memory1 으로 부터 입력 15bit 를 받는다. <br/>
이때 Rank_cal 의 입력으로 들어오는 15bit 의 왼쪽 5bit 는 시간 정보이고 오른쪽 10bit 는 누적교통량 정보이다. <br/>
그러면 Rank_cal 은 위와 같이 구성된 15bit 를 받으면 해당 시각에 누적 교통량이 몇 위인지 시간에 따라 순위를 내림차순 정렬을 해준다. <br/>

## 각 System 설명
### System 1. Digital Clock

<p center="align" style="margin: 20px 0;">
  <img width="90%" alt="Digital Clock Schematic" src="https://github.com/user-attachments/assets/7e2a6bd6-77ea-4219-9bc2-fe27b33bcc69" />
</p>

&nbsp;Clock 모듈은 시간 값을 출력한다. Clk 을 받아서 시간을 생성하고 각 모듈에 시간 값을 뿌려준다.
다른 모듈들은 그 시간 값을 참고하여 값을 저장하거나 traffic 을 통제한다.

``` verilog
  always_ff @(posedge CLK or negedge RSTN) begin
    if (!RSTN) begin
    
  end
```
