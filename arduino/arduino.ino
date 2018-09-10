int hazerOn = 9;
int hazerOff = 8;
bool isHazable = true;
bool hazerStatus = false;
long curTime;
long offTime;



void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);

  pinMode(hazerOn, OUTPUT);
  pinMode(hazerOff, OUTPUT);
  digitalWrite(hazerOff, LOW);
  digitalWrite(hazerOn, LOW);
}

void loop() {
  // put your main code here, to run repeatedly:
  if (Serial.available()) {
    int value = Serial.read();
    if (value == 49 && isHazable) {
      isHazable = false;
      hazerStatus = true;
      curTime = millis();
      digitalWrite(hazerOn, HIGH);
      delay(200);
      Serial.println("hazering");
      digitalWrite(hazerOn, LOW);
    }
  }
  if (millis() - curTime > 10000 && isHazable == false) {
    isHazable = true;
  }
  if (millis() - curTime > 2000 && hazerStatus) {
    hazerStatus = false;
    digitalWrite(hazerOff, HIGH);
    Serial.println("hazer end");
    delay(100);
    digitalWrite(hazerOff, LOW);
    digitalWrite(hazerOff, HIGH);
    delay(100);
    digitalWrite(hazerOff, LOW);
  }
}
