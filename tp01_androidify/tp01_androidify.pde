///  ARQUIVO: tp01_androidify.pde
///  EQUIPE:
///          Lucas Samuel Vieira - 24072
///  DATA:
///          05/04/2015
///  VERSÃO:
///          1.0
///  DESCRIÇÃO:
///          Clone do Androidify, feito em Processing.





/// FUNÇÃO: clamp(value, min, max)
///     Mantém um valor dentro de certo intervalo.
/// PARÂMETROS:
///      value  Valor a ser tratado
///      min    Valor mínimo do intervalo
///      max    Valor máximo do intervalo
/// RETORNO:
///      valor inicial, após tratado de acordo.
float clamp(float value, float min, float max) {
  return (value < min ? min : (value > max ? max : value));
}

/// CLASSE: vec2
///      Representa um vetor de duas dimensões em um plano.
public class vec2
{
  /// CAMPO: x
  ///        Coordenada X de um vector2
  public float x;
  /// CAMPO: y
  ///        Coordenada X de um vector2
  public float y;

  /// CTOR: vec2(X, Y)
  ///      Constrói um vetor de duas dimensões.
  /// PARÂMETROS:
  ///      X  Valor a ser atribuído à coordenada X
  ///      Y  Valor a ser atribuído à coordenada Y
  public vec2(float X, float Y) {
    x = X; y = Y;
  }
  
  /// CTOR: vec2(val)
  ///      Constrói um vetor de duas dimensões.
  /// PARÂMETROS:
  ///      val  Valor a ser atribuído às coordenadas X e Y
  public vec2(float val) {
    x = y = val;
  }
  
  /// CTOR: vec2()
  ///      Constrói um vetor de duas dimensões.
  public vec2() {
    this(0.0f);
  }
  
  /// MÉTODO: getDistance(v)
  ///     Determina a distância entre o ponto atual e outro.
  /// PARÂMETROS:
  ///      v  Ponto com o qual comparar.
  ///  RETORNO:
  ///      distância absoluta entre os dois pontos.
  public float getDistance(vec2 v) {
    return dist(x, y, v.x, v.y);
  }
  
  /// MÉTODO: getDistance(X, Y)
  ///     Determina a distância entre o ponto atual e outro.
  /// PARÂMETROS:
  ///      X  Coordenada X do ponto com o qual comparar.
  ///      Y  Coordenada Y do ponto com o qual comparar.
  ///  RETORNO:
  ///      distância absoluta entre os dois pontos.
  public float getDistance(float X, float Y) {
    return dist(x, y, X, Y);
  }
}

/// CLASSE: jointstate
///      Representa o estado de uma joint em um dado momento.
public class jointstate
{
  private vec2 position;
  private float angle;
  
  /// CTOR: jointstate(position, angle, displace_position)
  ///  PARÂMETROS:
  ///      position  Posição da joint no estado atual.
  ///      angle    Ângulo da joint no estado atual.
  public jointstate(vec2 position, float angle)
  {
    this.position = position;
    this.angle = angle;
  }
  
  /// MÉTODO: getPosition()
  /// RETORNO: Posição da joint no estado atual.
  public vec2 getPosition() {
    return position;
  }
  
  /// MÉTODO: getAngle()
  /// RETORNO: Ângulo da joint no estado atual.
  public float getAngle() {
    return angle;
  }
}

/// CLASSE: joint
///      Representa uma "junta" na animação do robô.
public class joint
{

  private float max_angle = 360;
  private float min_angle = 180;

  private vec2 position;
  private float angle;
  private joint parent;
  private jointstate defaults;
  
  /// CTOR: joint(position, minAngle, maxAngle, angle, displaceangle,
  ///                                                     displacepos)
  /// PARÂMETROS:
  ///      position  Posição da joint. Dada uma joint-pai, a posição
  ///            será relativa à mesma.
  ///      minAngle  Ângulo mínimo para a joint.
  ///      maxAngle  Ângulo máximo para a joint.
  ///      angle    Ângulo inicial a ser assumido pela joint.
  public joint(vec2 position, float minAngle, float maxAngle,
               float angle)
  {
    this.position = position;
    max_angle = maxAngle;
    min_angle = minAngle;
    this.angle = clamp(angle, minAngle, maxAngle);
    defaults = new jointstate(this.position, this.angle);
  }
  
  /// CTOR: joint(xpos, ypos, minAngle, maxAngle, angle, displaceangle,
  ///                                                     displacepos)
  /// PARÂMETROS:
  ///      xpos    Posição X da joint. Dada uma joint-pai, a posição
  ///            será relativa à mesma.
  ///      ypos    Posição Y da joint. Dada uma joint-pai, a posição
  ///            será relativa à mesma.
  ///      minAngle  Ângulo mínimo para a joint.
  ///      maxAngle  Ângulo máximo para a joint.
  ///      angle    Ângulo inicial a ser assumido pela joint.
  ///      displace  Deslocamento da joint.
  public joint(float xpos, float ypos, float minAngle, float maxAngle,
         float angle) {
    this(new vec2(xpos, ypos), minAngle, maxAngle, angle);
  }
  
  /// MÉTODO: setParent(j)
  ///      Configura uma joint como sendo pai da atual.
  ///  PARÂMETROS:
  ///      j  Joint a ser adotada como pai.
  public void setParent(joint j) {
    parent = j;
  }
  
  ///  MÉTODO: setPosition(position)
  ///      Atualiza a posição da joint.
  ///  PARÂMETROS:
  ///      position  Posição a ser assumida pela joint.
  public void setPosition(vec2 position) {
    this.position.x = position.x;
    this.position.y = position.y;
  }
  
  /// MÉTODO: setAngle(angle)
  ///      Atualiza o ângulo da joint.
  /// PARÂMETROS:
  ///      angle  Ângulo a ser assumido pela joint.
  public void setAngle(float angle) {
    this.angle = clamp(angle, min_angle, max_angle);
  }
  
  ///  MÉTODO: resetState()
  ///      Reposiciona a joint atual e redefine seu ângulo para o padrão.
  public void resetState() {
    this.position.x = defaults.getPosition().x;
    this.position.y = defaults.getPosition().y;
    this.angle = defaults.getAngle();
  }
  
  /// MÉTODO: getPosition()
  /// RETORNO: Posição atual da joint.
  public vec2 getPosition() {
    return position;
  }
  
  /// MÉTODO: getAngle()
  /// RETORNO: Ângulo atual da joint.
  public float getAngle() {
    return angle;
  }
  
  /// MÉTODO: getParent()
  /// RETORNO: Referência à joint-pai da joint atual.
  public joint getParent() {
    return parent;
  }
  
  /// MÉTODO: transformToParents()
  ///      Transforma a matriz atual afim de posicioná-la exatamente
  ///      na posição da joint-pai, caso existente.
  public void transformToParents() {
  if(parent != null) {
      parent.transformToParents();
      translate(parent.getPosition().x, parent.getPosition().y);
      rotate(radians(parent.getAngle() - 90.0f));
    }
  }
  
  /// MÉTODO: translateTo()
  ///      Faz a translação da matriz atual para a posição da joint.
  public void translateTo() {
    transformToParents();
    translate(position.x, position.y);
  }
  
  /// MÉTODO: translateTo()
  ///      Faz a rotação da matriz atual para a posição da joint.
  public void rotateTo() {
    rotate(radians(angle) + radians(90));
  }
  
  /// MÉTODO: draw()
  ///      Desenha uma joint (para debug).
  public void draw()
  {
    pushMatrix();
      if(parent != null) {
        // Desenhe uma linha até a junta-pai e rotacione-se de acordo.
        stroke(255, 255, 0);
        transformToParents();
        line(0.0f, 0.0f, position.x, position.y);
      }
      translate(position.x, position.y);
      pushMatrix();
        fill(0, 0, 255);
        stroke(0, 0, 255);
        color(0, 0, 255);
        // Ponto
        ellipse(0.0f, 0.0f, 5.0f, 5.0f);
        // Limitador de ângulos
        noFill();
        stroke(0, 255, 0);
        arc(0.0f, 0.0f, 15.0f, 15.0f,
          radians(min_angle), radians(max_angle));
      popMatrix();
      // Ângulo atual
      rotate(radians(angle) + radians(90));
      pushMatrix();
        stroke(255, 0, 0);
        //strokeWeight(3);
        line(0.0f, 0.0f, 0.0f, -25.0f);
        //strokeWeight(1);
      popMatrix();
    popMatrix();
  }
}

/// CLASSE: AndroidRobot
///      Define um robô.
public class AndroidRobot
{
  private vec2 position;
  private joint body_j,
                head_j,
                l_antenna_j,
                r_antenna_j,
                l_arm_j,
                r_arm_j,
                l_leg_j,
                r_leg_j,
                l_foot_j,
                r_foot_j;
  private final float head_w_o    = 160.0f,
              head_h_o    = 160.0f,
              antenna_h   = 30.0f,
              arm_w_o     = 40.0f,
              arm_h_o     = 80.0f,
              leg_w_o     = 40.0f,
              leg_h_o     = 80.0f,
              torso_w_o   = 160.0f,
              torso_h_o   = 160.0f;
  private float head_w,
          head_h,
            arm_w,
          arm_h,
          leg_w,
          leg_h,
          torso_w,
          torso_h;
  private float head_f,
          arm_f,
          leg_f,
          torso_f;
  private boolean visible = true,
                  visible_joints = false,
                  visible_shoes = false,
                  visible_glasses = false,
                  visible_hat = false,
                  visible_clockwatch = false;
  private color c;
  
  private int ActionType;
  
  private float movementCounter;
  private final float arm_max_speed = 10.0f;
  private final float arm_accel = 2.5f;
  
  private int blinkCounter,
        blinkCounter2;
  
  /// CTOR: AndroidRobot(position)
  /// PARÂMETROS:
  ///      position  Posição inicial para o robô.
  public AndroidRobot(vec2 position)
  {
    this.position = position;
    c = color(163, 201, 56);
    // Criando juntas
    body_j = new joint(position, 225.0f, 315.0f, 270.0f);
    head_j = new joint(0.0f, 120.0f, 45.0f, 135.0f, 90.0f);
    
    l_antenna_j = new joint(33.0f, 63.0f, 0.0f, 180.0f, 45.0f);
    r_antenna_j = new joint(-33.0f, 63.0f, 0.0f, 180.0f, 135.0f);
    
    l_arm_j = new joint(110.0f, 96.0f, -360.0f, 360.0f, -90.0f);
    r_arm_j = new joint(-110.0f, 96.0f,-360.0f, 360.0f, 270.0f);
    
    l_leg_j = new joint(35.0f, -20.0f, -135.0f, 90.0f, -90.0f);
    r_leg_j = new joint(-35.0f,-20.0f, 90.0f, 315.0f, 270.0f);
    
    l_foot_j = new joint(0.0f, 90.0f, 90.0f, 225.0f, 180.0f);
    r_foot_j = new joint(0.0f, 90.0f, -45.0f, 90.0f, 0.0f);
    
    head_j.setParent(body_j);
    l_antenna_j.setParent(head_j);
    r_antenna_j.setParent(head_j);
    l_arm_j.setParent(body_j);
    r_arm_j.setParent(body_j);
    l_leg_j.setParent(body_j);
    r_leg_j.setParent(body_j);
    l_foot_j.setParent(l_leg_j);
    r_foot_j.setParent(r_leg_j);
  }

  /// MÉTODO: setPosition(position)
  ///      Redefine a posição do robô.
  ///  PARÂMETROS:
  ///      position  Posição a ser assumida pelo robô.
  public void setPosition(vec2 position) {
    this.position.x = position.x;
    this.position.y = position.y;
  }
  
  /// MÉTODO: setColor(c)
  ///      Redefine a cor do robô.
  ///  PARÂMETROS:
  ///      c  Cor a ser assumida pelo robô.
  public void setColor(color c) {
    this.c = c;
  }
  
  /// MÉTODO: setHeadFactor(val)
  ///      Redefine o fator de dimensionamento da cabeça.
  ///  PARÂMETROS:
  ///      val    Fator de redimensionamento [-1, 1] a ser usado.
  public void setHeadFactor(float val) {
    val = clamp(val, -1.0f, 1.0f);
    head_f = val;
  }
  
  /// MÉTODO: setTorsoFactor(val)
  ///      Redefine o fator de dimensionamento do torso.
  ///  PARÂMETROS:
  ///      val    Fator de redimensionamento [-1, 1] a ser usado.
  public void setTorsoFactor(float val) {
    val = clamp(val, -1.0f, 1.0f);
    torso_f = val;
  }
  
  /// MÉTODO: setArmsFactor(val)
  ///      Redefine o fator de dimensionamento dos braços.
  ///  PARÂMETROS:
  ///      val    Fator de redimensionamento [-1, 1] a ser usado.
  public void setArmsFactor(float val) {
    val = clamp(val, -1.0f, 1.0f);
    arm_f = val;
  }
  
  /// MÉTODO: setLegsFactor(val)
  ///      Redefine o fator de dimensionamento das pernas.
  ///  PARÂMETROS:
  ///      val    Fator de redimensionamento [-1, 1] a ser usado.
  public void setLegsFactor(float val) {
    val = clamp(val, -1.0f, 1.0f);
    leg_f = val;
  }

  /// MÉTODO: setAction(type)
  ///      Redefine a ação do robô.
  /// PARÂMETROS:
  ///      type: Valor [0, 2] para a ação do robô.
  ///          Valores disponíveis:
  ///          0: Parado
  ///          1: Acenar braço
  ///          2: Dançar
  public void setAction(int type) {
    if(type != ActionType) {
      body_j.resetState();
        head_j.resetState();
        l_antenna_j.resetState();
        r_antenna_j.resetState();
        l_arm_j.resetState();
        r_arm_j.resetState();
        l_leg_j.resetState();
        r_leg_j.resetState();
        l_foot_j.resetState();
        r_foot_j.resetState();
        movementCounter = 0.0f;
    }
    if(type < 0 || type > 2)
      type = 0;
    ActionType = type;
  }

  /// MÉTODO: getAction()
  /// RETORNO: Valor [0, 2] indicando a ação atual realizada pelo robô.
  ///      Para mais informações, veja setAction(type).
  public int getAction() {
    return ActionType;
  }

  /// MÉTODO: action_wave()
  ///      Lógica para a ação de acenar.
  private void action_wave()
  {
    if(r_arm_j.getAngle() < 135.0f)
      movementCounter += arm_accel;
    else if(r_arm_j.getAngle() > 135.0f)
      movementCounter -= arm_accel;
    if(body_j.getAngle() > 263.0f)
      body_j.setAngle(body_j.getAngle () - 1.0f);
    else body_j.setAngle(263.0f);
    if(l_leg_j.getAngle() < -83.0f)
      l_leg_j.setAngle(l_leg_j.getAngle() + 1.0f);
    else l_leg_j.setAngle(-83.0f);
    if(l_arm_j.getAngle() < -83.0f)
      l_arm_j.setAngle(l_arm_j.getAngle() + 1.0f);
    else l_arm_j.setAngle(-83.0f);
    movementCounter = clamp(movementCounter, -arm_max_speed, arm_max_speed);
    r_arm_j.setAngle(r_arm_j.getAngle() + movementCounter);
  }

  /// MÉTODO: action_wave()
  ///      Lógica para a ação de dançar.
  private void action_dance()
  {
    float danceAngle = 22.5f;
    movementCounter += 0.1f;
    if(movementCounter > TAU) movementCounter -= TAU;
    head_j.setAngle(90.0f - (sin(movementCounter) * danceAngle / 2.0f));
    body_j.setAngle(270.0f + (sin(movementCounter) * danceAngle));
    l_antenna_j.setAngle(45.0f - (sin(movementCounter) * danceAngle));
    r_antenna_j.setAngle(135.0f - (sin(movementCounter) * danceAngle));
    l_arm_j.setAngle(-90.0f - (sin(movementCounter) * danceAngle));
    r_arm_j.setAngle(-90.0f - (sin(movementCounter) * danceAngle));
    l_leg_j.setAngle(-90.0f - (sin(movementCounter) * danceAngle));
    r_leg_j.setAngle(270.0f - (sin(movementCounter) * danceAngle));
  }
  
  /// MÉTODO: action_wave()
  ///      Lógica para a ação de estar parado (move as antenas).
  private void action_stand()
  {
    // When standing, antennas should move slightly
    if(r_antenna_j.getAngle() < 112.5f)
      movementCounter += arm_accel / 100.0f;
    else if(r_antenna_j.getAngle() > 112.5f)
      movementCounter -= arm_accel / 100.0f;
    movementCounter = clamp(movementCounter, -arm_max_speed / 10.0f,
                            arm_max_speed / 10.0f);
    r_antenna_j.setAngle(r_antenna_j.getAngle() + movementCounter);
    l_antenna_j.setAngle(180 - (r_antenna_j.getAngle() + movementCounter));
  }
  
  /// MÉTODO: update()
  ///      Atualiza lógicas variadas do robô.
  public void update() {
    // Define widths and heights with factors.
    head_w = head_w_o + (head_w_o * head_f);
    head_h = head_h_o + (head_h_o * head_f);
      arm_w  = arm_w_o;
    arm_h  = arm_h_o + (arm_h_o * arm_f);
    leg_w  = leg_w_o;
    leg_h  = leg_h_o + (leg_h_o * leg_f);
    torso_w = torso_w_o + (torso_w_o * torso_f);
    torso_h = torso_h_o + (torso_h_o * torso_f);
    
    // Repositioning by scale
    // vs. Torso
    // Head
    head_j.setPosition(new vec2(0.0f, 120.0f + (torso_h_o/2.0f * torso_f)));
    
    // Arms
    l_arm_j.setPosition(new vec2(110.0f + (torso_w_o/2.0f * torso_f),
                    96.0f + (torso_h_o/2.0f * torso_f)));
    r_arm_j.setPosition(new vec2(-110.0f - (torso_w_o/2.0f * torso_f),
                    96.0f + (torso_h_o/2.0f * torso_f)));
    // Legs
    l_leg_j.setPosition(new vec2(35.0f + (torso_w_o/2.0f * torso_f),
                    -20.0f - (torso_h_o/2.0f * torso_f)));
    r_leg_j.setPosition(new vec2(-35.0f - (torso_w_o/2.0f * torso_f),
                    -20.0f - (torso_h_o/2.0f * torso_f)));
    // Feet vs. legs
    l_foot_j.setPosition(new vec2(0.0f, leg_h));
    r_foot_j.setPosition(new vec2(0.0f, leg_h));
    
    // Antennas vs. Head
    l_antenna_j.setPosition(new vec2(33.0f + (head_w_o/3.0f * head_f),
                      63.0f + (head_h_o/3.0f * head_f)));
    r_antenna_j.setPosition(new vec2(-33.0f - (head_w_o/3.0f * head_f),
                      63.0f + (head_h_o/3.0f * head_f)));
  
    switch(ActionType) {
    default:
      action_stand();
      break;
    case 1: // Wave arm
      action_wave();
      break;
    case 2: // Dance
      action_dance();
      break;
    }
    
    // Routine for eyes blinking.
    // See more at drawEyes.
    if(blinkCounter < 120) blinkCounter++;
    else {
      blinkCounter2++;
      if(blinkCounter2 > 7) {
        blinkCounter = int(random(120));
        blinkCounter2 = 0;
      }
    }
  }

  /// MÉTODO: drawAntennas()
  ///      Desenha as antenas do robô.
  private void drawAntennas() {
    // Left antenna
    pushMatrix();
    fill(c);
    stroke(c);
    l_antenna_j.translateTo();
    scale(-1, -1);
    l_antenna_j.rotateTo();
    rect(0, 0, 5.0f, antenna_h, 5.0f);
    popMatrix();
    
    // Right antenna
    pushMatrix();
    fill(c);
    stroke(c);
    r_antenna_j.translateTo();
    scale(-1, -1);
    r_antenna_j.rotateTo();
    rect(0, 0, 5.0f, antenna_h, 5.0f);

    popMatrix();
  }
  
  /// MÉTODO: drawHead()
  ///      Desenha a cabeça do robô.
  private void drawHead() {
    pushMatrix();
    head_j.translateTo();
    head_j.rotateTo();
    scale(1, -1);
    fill(c);
    stroke(c);
      arc(0, 0, head_w, head_h, 0, PI, PIE);
    popMatrix();
  }
  
  /// MÉTODO: drawArms()
  ///      Desenha os braços do robô.
  private void drawArms() {
    // Left arm
    pushMatrix();
    l_arm_j.translateTo();
    l_arm_j.rotateTo();
    fill(c);
    stroke(c);
    // adjust
    translate(0.0f, -5.0f);
    arc(0, 0, arm_w, 40.0f, 0, PI, PIE);
    scale(1, -1);
    translate(-arm_w/2.0f, 0.0f);
    rect(0, 0, arm_w, arm_h);
    translate(arm_w/2.0f, arm_h);
    arc(0, 0, arm_w, 40.0f, 0, PI, PIE);
    popMatrix();
    
    // Right arm
    pushMatrix();
    r_arm_j.translateTo();
    r_arm_j.rotateTo();
    fill(c);
    stroke(c);
    // adjust
    translate(0.0f, -5.0f);
    arc(0, 0, arm_w, 40.0f, 0, PI, PIE);
    scale(1, -1);
    translate(-arm_w/2.0f, 0.0f);
    rect(0, 0, arm_w, arm_h);
    translate(arm_w/2.0f, arm_h);
    arc(0, 0, arm_w, 40.0f, 0, PI, PIE);
    popMatrix();
  }
  
  /// MÉTODO: drawLegs()
  ///      Desenha as pernas do robô.
  private void drawLegs() {
    // Left leg
    pushMatrix();
    l_leg_j.translateTo();
    l_leg_j.rotateTo();
    fill(c);
    stroke(c);
    // adjust
    scale(1, -1);
    translate(-leg_w/2.0f, -5.0f);
    rect(0, 0, leg_w, leg_h);
    translate(leg_w/2.0f, leg_h);
    arc(0, 0, leg_w, 40.0f, 0, PI, PIE);
    popMatrix();
    
    // Right leg
    pushMatrix();
    r_leg_j.translateTo();
    r_leg_j.rotateTo();
    fill(c);
    stroke(c);
    // adjust
    scale(1, -1);
    translate(-leg_w/2.0f, -5.0f);
    rect(0, 0, leg_w, leg_h);
    translate(leg_w/2.0f, leg_h);
    arc(0, 0, leg_w, 40.0f, 0, PI, PIE);
    popMatrix();
  }
  
  /// MÉTODO: drawTorso()
  ///      Desenha o torso do robô.
  private void drawTorso() {
    pushMatrix();
    body_j.translateTo();
    body_j.rotateTo();
    fill(c);
    stroke(c);
    translate(-80.0f, -110.0f);
    rect((-torso_w_o/2.0f * torso_f), (-torso_h_o/2.0f * torso_f),
                  torso_w, torso_h, 0.0f, 0.0f, 50.0f, 50.0f);
    popMatrix();
  }
  
  /// MÉTODO: drawEyes()
  ///      Desenha os olhos do robô.
  private void drawEyes() {
    // blinkCounter < 120: Eyes open
    // blinkCounter >= 120: Eyes blinking
    float eyeHeight;
    if(blinkCounter < 120) eyeHeight = 10.0f;
    else eyeHeight = 1.0f;
    
    fill(255);
    stroke(255);
    pushMatrix();
      head_j.translateTo();
      head_j.rotateTo();
      pushMatrix();
        translate(-40 - (head_w_o/3.0f * head_f),
                        -40 - (head_h_o/3.0f * head_f));
        ellipse(0.0f, 0.0f, 10.0f, eyeHeight);
      popMatrix();
      pushMatrix();
        translate(40 + (head_w_o/3.0f * head_f),
                        -40 - (head_h_o/3.0f * head_f));
        ellipse(0.0f, 0.0f, 10.0f, eyeHeight);
      popMatrix();
    popMatrix();
  }
  
  /// MÉTODO: setShoesVisible(val)
  ///     Define o estado de visibilidade dos sapatos.
  /// PARÂMETROS:
  ///      val    Estado de visibilidade dos sapatos a ser assumido.
  public void setShoesVisible(boolean val) {
    visible_shoes = val;
  }
  
  ///  MÉTODO: getShoesVisible()
  /// RETORNO: Se os sapatos estão visíveis ou não.
  public boolean getShoesVisible() {
    return visible_shoes;
  }
  
  private void drawShoes() {
    if(!visible_shoes) return;
    pushMatrix();
      l_foot_j.translateTo();
      l_foot_j.rotateTo();
      translate(-leg_w, -leg_w/2.0f);
      noStroke();
      fill(80, 0, 0);
      rect(0.0f, -1.0f, (leg_w*1.5f), leg_w + 2);
      arc(0.0f, 0.0f, leg_w * 2.0f, leg_w * 2.0f, PI + HALF_PI, TAU);
      translate(-10.0f, -leg_w);
      fill(255);
      rect(0.0f, 0.0f, 10.0f, leg_w*2.0f);
    popMatrix();
    
    pushMatrix();
      r_foot_j.translateTo();
      r_foot_j.rotateTo();
      translate(leg_w, -leg_w/2.0f);
      scale(-1, 1);
      noStroke();
      fill(80, 0, 0);
      rect(0.0f, -1.0f, (leg_w*1.5f), leg_w + 2);
      arc(0.0f, 0.0f, leg_w * 2.0f, leg_w * 2.0f, PI + HALF_PI, TAU);
      translate(-10.0f, -leg_w);
      fill(255);
      rect(0.0f, 0.0f, 10.0f, leg_w*2.0f);
    popMatrix();
  }
  
  /// MÉTODO: setGlassesVisible(val)
  ///     Define o estado de visibilidade dos óculos.
  /// PARÂMETROS:
  ///      val    Estado de visibilidade dos óculos a ser assumido.
  public void setGlassesVisible(boolean val) {
    visible_glasses = val;
  }
  
  ///  MÉTODO: getGlassesVisible()
  /// RETORNO: Se os óculos estão visíveis ou não.
  public boolean getGlassesVisible() {
    return visible_glasses;
  }
  
  private void drawGlasses() {
    if(!visible_glasses) return;
    pushMatrix();
      head_j.translateTo();
      head_j.rotateTo();
      noFill();
      strokeWeight(5);
      stroke(90);
      // Middle handle
      pushMatrix();
        translate(0.0f, -40 - (head_h_o/3.0f * head_f));
        arc(0.0f, 0.0f, 30.0f + (head_h_o/1.5f * head_f), 30.0f, PI, TAU);
      popMatrix();
      
      // Left
      pushMatrix();
        translate(-40 - (head_w_o/3.0f * head_f),
                        -40 - (head_h_o/3.0f * head_f));
        ellipse(0.0f, 0.0f, 50.0f, 50.0f);
      popMatrix();
      // Right
      pushMatrix();
        translate(40 + (head_w_o/3.0f * head_f),
                        -40 - (head_h_o/3.0f * head_f));
        ellipse(0.0f, 0.0f, 50.0f, 50.0f);
      popMatrix();
    popMatrix();
    strokeWeight(1);
  }
  
  /// MÉTODO: setHatVisible(val)
  ///     Define o estado de visibilidade do chapéu.
  /// PARÂMETROS:
  ///      val    Estado de visibilidade do chapéu a ser assumido.
  public void setHatVisible(boolean val) {
    visible_hat = val;
  }
  
  ///  MÉTODO: getHatVisible()
  /// RETORNO: Se o chapéu está visível ou não.
  public boolean getHatVisible() {
    return visible_hat;
  }

  private void drawHat() {
    if(!visible_hat) return;
    pushMatrix();
      head_j.translateTo();
      head_j.rotateTo();
      rotate(radians(-22.5));
      noStroke();
      fill(20);
      translate(0.0f, -80 - (head_h_o/3.0f * head_f));
      ellipse(0.0f, 0.0f, 80.0f, 40.0f);
      stroke(255);
      noFill();
      ellipse(0.0f, 0.0f, 65.0f, 15.0f);
      noStroke();
      fill(20);
      ellipse(0.0f, 0.0f, 50.0f, 15.0f);
      fill(20);
      rect(-25.0f, -50.0f, 50.0f, 50.0f);
      stroke(90);
      ellipse(0.0f, -50.0f, 50.0f, 15.0f);
    popMatrix();
  }

  /// MÉTODO: setClockwatchVisible(val)
  ///     Define o estado de visibilidade do relógio de pulso.
  /// PARÂMETROS:
  ///      val    Estado de visibilidade do relógio a ser assumido.
  public void setClockwatchVisible(boolean val) {
    visible_clockwatch = val;
  }
  
  ///  MÉTODO: getClockwatchVisible()
  /// RETORNO: Se o relógio de pulso está visível ou não.
  public boolean getClockwatchVisible() {
    return visible_clockwatch;
  }

  private void drawClockwatch() {
    if(!visible_clockwatch) return;
    pushMatrix();
      l_arm_j.translateTo();
      l_arm_j.rotateTo();
      scale(1, -1);
      noStroke();
      translate(0.0f, arm_h - 5.0f);
      fill(20);
      rect(-arm_w/2.0f - 1.0f, 0.0f, arm_w + 2.0f, 10.0f);
      fill(135, 206, 235);
      translate(0.0f, 5.0f);
      ellipse(0.0f, 0.0f, 20.0f, 20.0f);
      stroke(90);
      strokeWeight(3);
      line(0.0f, 0.0f, -8.0f, 0.0f);
      strokeWeight(1);
      line(0.0f, 0.0f, 0.0f, 8.0f);
      fill(240, 255, 255);
      noStroke();
      ellipse(-1.0f, 1.0f, 5.0f, 5.0f);
    popMatrix();
  }

  /// MÉTODO: draw_joints()
  ///      Desenha as joints do robô.
  private void draw_joints()
  {
    l_antenna_j.draw();
    r_antenna_j.draw();
    head_j.draw();
    l_arm_j.draw();
    r_arm_j.draw();
    l_foot_j.draw();
    r_foot_j.draw();
    l_leg_j.draw();
    r_leg_j.draw();
    body_j.draw();
  }
  
  /// MÉTODO: draw_robot()
  ///      Desenha o robô.
  private void draw_robot()
  {
    drawAntennas();
    drawHead();
    drawHat();
    drawEyes();
    drawGlasses();
    drawLegs();
    drawShoes();
    drawTorso();
    drawArms();
    drawClockwatch();
  }
  
  /// MÉTODO: setVisible(val)
  ///      Define a visibilidade do robô.
  ///  PARÂMETROS:
  ///      val    Se o robô estará visível ou não.
  public void setVisible(boolean val) {
    visible = val;
  }
  
  /// MÉTODO: getVisible()
  /// RETORNO: Se o robô está visível ou não.
  public boolean getVisible() {
    return visible;
  }
  
  /// MÉTODO: setVisibleJoints(val)
  ///      Define a visibilidade das joints do robô.
  ///  PARÂMETROS:
  ///      val    Se as joints estarão visíveis ou não.
  public void setVisibleJoints(boolean val) {
    visible_joints = val;
  }
  
  /// MÉTODO: getVisibleJoints()
  /// RETORNO: Se as joints do robô estão visíveis ou não.
  public boolean getVisibleJoints() {
    return visible_joints;
  }
  
  /// MÉTODO: draw()
  ///      Efetivamente desenha o robô. Sua visibilidade e a visibilidade
  ///      das joints são definidas por métodos externos. Veja os getters
  ///      e setters de Visible e VisibleJoints para mais detalhes.
  public void draw() {
    if(visible)
      draw_robot();
    if(visible_joints)
      draw_joints();
  }

}

/// CLASSE: Panel
///      Define o painel de controle lateral.
public class Panel
{
  /// CLASSE: ScrollBar
  ///      Define uma barra de rolagem.
  public class ScrollBar
  {
    // Scrollbar size: 5x10
    // Slider size:
    vec2 position;
    float sliderPosition;
    float sliderSize = 250.0f;
    float factor;
    boolean dragged = false;
    
    /// CTOR: ScrollBar(xpos, ypos)
    /// PARÂMETROS:
    ///      xpos  Posição X da barra de rolagem.
    ///      ypos  Posição Y da barra de rolagem.
    public ScrollBar(float xpos, float ypos)
    {
      position = new vec2(xpos, ypos);
      setFactor(0.0f);
    }
    
    ///  MÉTODO: isMouseOver(oldmousepos)
    ///  PARÂMETROS:
    ///      oldmousepos    Posição do mouse.
    ///  RETORNO: Se o mouse está sobre o slider da barra ou não.
    public boolean isMouseOver(vec2 oldmousepos) {
      // Adjust mousepos to relative coordinates
      vec2 mousepos = new vec2(oldmousepos.x, oldmousepos.y);
      mousepos.x -= position.x;
      mousepos.y -= position.y;
      return (mousepos.x >= sliderPosition - 2.5f &&
          mousepos.x <= sliderPosition + 2.5f &&
          mousepos.y >= -5.0f && mousepos.y <= 5.0f);
    }
    
    /// MÉTODO: setFactor(val)
    ///     Define o fator de posição da barra de rolagem.
    ///  PARÂMETROS:
    ///      val    Valor de posição [-1, 1] a ser assumido.
    public void setFactor(float val) {
      factor = clamp(val, -1.0f, 1.0f);
      sliderPosition = sliderSize * ((factor + 1.0f) / 2.0f);
    }
    
    /// MÉTODO: getFactor()
    ///  RETORNO: Fator de posição da barra de rolagem.
    public float getFactor() {
      return factor;
    }
    
    private void recalcFactor() {
      factor = ((sliderPosition / sliderSize) * 2.0f) - 1.0f;
    }
    
    /// MÉTODO: update()
    ///      Atualiza a lógica da barra de rolagem.
    public void update() {
      // if dragged, get mouse position et all
      // Compare if mouse is released. If it is, then just
      // stop dragging.
      if(dragged) {
        sliderPosition = mouseX - position.x;
        sliderPosition = clamp(sliderPosition, 0.0f, sliderSize);
        recalcFactor();
      }
    }

    /// MÉTODO: getDragged()
    ///  RETORNO: Se o slider está sendo arrastado ou não.
    public boolean getDragged() {
      return dragged;
    }

    /// MÉTODO: setDragged(state)
    ///      Define o estado do slider, se deverá ser arrastado ou não.
    /// PARÂMETROS:
    ///      state  Estado a ser assumido pelo slider.
    public void setDragged(boolean state) {
      dragged = state;
    }
    
    /// MÉTODO: draw()
    ///      Desenha a barra de rolagem.
    public void draw() {
      pushMatrix();
        translate(position.x, position.y);
        stroke(secondary_text);
        fill(secondary_text);
        // Beginning
        line(0.0f, -5.0f, 0.0f, 5.0f);
        // Scroll line
        line(0.0f, 0.0f, sliderSize, 0.0f);
        // Middle
        line(sliderSize/2.0f, -5.0f, sliderSize/2.0f, 5.0f);
        // End
        line(sliderSize, -5.0f, sliderSize, 5.0f);
        // Slider
        pushMatrix();
          translate(sliderPosition, 0.0f);
          rect(-2.5f, -5.0f, 5.0f, 10.0f);
        popMatrix();
        noStroke();
      popMatrix();
    }
  }

  private vec2 position;
  private boolean showing = false;
  private final float panel_accel = 2.0f;
  private float panel_xspeed = 0.0f;
  private ScrollBar headSlider,
            torsoSlider,
            armsSlider,
            legsSlider;
  private float menu_button_angle;
  
  private color dark_red,
            red,
            deep_orange,
          text_icons,
          primary_text,
          secondary_text,
          divider,
          light_primary,
      
          android_green,
          marine_blue,
          water_green,
          purple,
          royal_red,
          yellow,
          pink,
          baby_blue,
          orange;
  
  private AndroidRobot r;
  
  
  /// CTOR: Panel(r)
  ///  PARÂMETROS:
  ///      r  Referência ao robô a ser modificado.
  public Panel(AndroidRobot r) {
    // Palette made in http://www.materialpalette.com/red/deep-orange
    // Convert colors from hex to rgb with
    //                https://www.easycalculation.com/color-coder.php
    position = new vec2(-(width/2.0f), 0.0f);
    dark_red = color(211, 47, 47);
    red = color(244, 67, 54);
    deep_orange = color(255, 87, 34);
    text_icons = color(255, 255, 255);
    primary_text = color(33, 33, 33);
    secondary_text = color(114, 114, 114);
    divider = color(182, 182, 182);
    light_primary = color(255, 205, 210);
    
    android_green = color(163, 201, 56);
    marine_blue = color(0, 51, 102);
    water_green = color(26, 227, 171);
    purple = color(116, 12, 110);
    royal_red = color(116, 12, 12);
    yellow = color(237, 206, 19);
    pink = color(255, 125, 236);
    baby_blue = color(137, 207, 240);
    orange = color(255, 153, 0);
    
    this.r = r;
    
    headSlider = new ScrollBar(70 + (width / 32.0f),
                        25 * (height / 32.0f) + 5.0f);
    torsoSlider = new ScrollBar(70 + (width / 32.0f),
                        26 * (height / 32.0f) + 5.0f);
    armsSlider = new ScrollBar(70 + (width / 32.0f),
                        27 * (height / 32.0f) + 5.0f);
    legsSlider = new ScrollBar(70 + (width / 32.0f),
                        28 * (height / 32.0f) + 5.0f);
  }
  
  /// MÉTODO: getPosition()
  ///  RETORNO: Posição atual do painel.
  public vec2 getPosition() {
    return position;
  }
  
  /// MÉTODO: togglePanel()
  ///      Interruptor para a visibilidade do painel. Cada chamada
  ///      inverterá o estado de visibilidade atual do mesmo.
  public void togglePanel() {
    showing = !showing;
    panel_xspeed = 0.0f;
  }
  
  /// MÉTODO: evalClick(clickpos)
  ///      Verifica cliques dentro do painel e realiza lógica de acordo.
  /// PARÂMETROS:
  ///      clickpos  Posição do clique.
  public void evalClick(vec2 clickpos) {
    // If you're hidden, then show.
    if(!showing) {
      if(clickpos.getDistance(30.0f, 30.0f) <= 25.0f)
        showing = true;
        panel_xspeed = 0.0f;
    }
  
    // Do not change anything unless you're
    // stopped and shown.
    if(position.x != 0.0f) return;
    
    // Hide if that's the case
    if(clickpos.getDistance((width / 2.0f) + 30.0f, 30.0f) <= 25.0f) { 
      showing = false;
      panel_xspeed = 0.0f;
    }
      
    // Fields
    // Toggle robot view
    if(clickpos.getDistance((width / 64.0f), 10 * (height / 32.0f) + 2)
        <= 7.5f)
      r.setVisible(!r.getVisible());
    // Toggle joint view
    if(clickpos.getDistance((width / 64.0f), 11 * (height / 32.0f) + 2)
        <= 7.5f)
      r.setVisibleJoints(!r.getVisibleJoints());
      
    
    // Change color
    // Android Green
    if(clickpos.getDistance((width / 32.0f) + 10.0f,
      14 * (height / 32.0f) + 8.0f) <= 15.0f)
      r.setColor(android_green);
    // Water Green
    if(clickpos.getDistance((width / 32.0f) + 44.0f,
      14 * (height / 32.0f) + 8.0f) <= 15.0f)
      r.setColor(water_green);
    // Purple
    if(clickpos.getDistance((width / 32.0f) + 80.0f,
      14 * (height / 32.0f) + 8.0f) <= 15.0f)
      r.setColor(purple);
    // Royal Red
    if(clickpos.getDistance((width / 32.0f) + 115.0f,
      14 * (height / 32.0f) + 8.0f) <= 15.0f)
      r.setColor(royal_red);
    // Yellow
    if(clickpos.getDistance((width / 32.0f) + 150.0f,
      14 * (height / 32.0f) + 8.0f) <= 15.0f)
      r.setColor(yellow);
    // Pink
    if(clickpos.getDistance((width / 32.0f) + 185.0f,
      14 * (height / 32.0f) + 8.0f) <= 15.0f)
      r.setColor(pink);
    // Marine Blue
    if(clickpos.getDistance((width / 32.0f) + 220.0f,
      14 * (height / 32.0f) + 8.0f) <= 15.0f)
      r.setColor(marine_blue);
    
    // Baby Blue
    if(clickpos.getDistance((width / 32.0f) + 255.0f,
      14 * (height / 32.0f) + 8.0f) <= 15.0f)
      r.setColor(baby_blue);
    
    // Orange
    if(clickpos.getDistance((width / 32.0f) + 290.0f,
      14 * (height / 32.0f) + 8.0f) <= 15.0f)
      r.setColor(orange);
    
    // Toggle acessories
    // Hat
    if(clickpos.x >= (width / 32.0f) - 5.0f
    && clickpos.x <= (width / 32.0f) - 5.0f + 70.0f
    && clickpos.y >= 18 * (height / 32.0f) - 9.0f
    && clickpos.y <= (18 * (height / 32.0f) - 9.0f) + 24.0f)
      r.setHatVisible(!r.getHatVisible());
    // Clockwatch
    if(clickpos.x >= 90 + (width / 32.0f) - 5.0f
    && clickpos.x <= (90 + (width / 32.0f) - 5.0f) + 70.0f
    && clickpos.y >= 18 * (height / 32.0f) - 9.0f
    && clickpos.y <= (18 * (height / 32.0f) - 9.0f) + 24.0f)
      r.setClockwatchVisible(!r.getClockwatchVisible());
    // Shoes
    if(clickpos.x >= 180 + (width / 32.0f) - 5.0f
    && clickpos.x <= (180 + (width / 32.0f) - 5.0f) + 70.0f
    && clickpos.y >= 18 * (height / 32.0f) - 9.0f
    && clickpos.y <= (18 * (height / 32.0f) - 9.0f) + 24.0f)
      r.setShoesVisible(!r.getShoesVisible());
    // Glasses
    if(clickpos.x >= 270 + (width / 32.0f) - 5.0f
    && clickpos.x <= (270 + (width / 32.0f) - 5.0f) + 70.0f
    && clickpos.y >= 18 * (height / 32.0f) - 9.0f
    && clickpos.y <= (18 * (height / 32.0f) - 9.0f) + 24.0f)
      r.setGlassesVisible(!r.getGlassesVisible());
    
    // Change animation
    // None
    if(clickpos.x >= (width / 32.0f)
    && clickpos.y >= 22 * (height / 32.0f) - 10
    && clickpos.x <= ((width / 32.0f) + 65)
    && clickpos.y <= 22 * (height / 32.0f) + 12) {
      r.setAction(0);
    }
    // Wave
    if(clickpos.x >= 6 * (width / 32.0f)
    && clickpos.y >= 22 * (height / 32.0f) - 10
    && clickpos.x <= (6 * (width / 32.0f) + 55)
    && clickpos.y <= 22 * (height / 32.0f) + 12) {
      r.setAction(1);
    }
    // Dance
    if(clickpos.x >= 11 * (width / 32.0f)
    && clickpos.y >= 22 * (height / 32.0f) - 10
    && clickpos.x <= (11 * (width / 32.0f) + 55)
    && clickpos.y <= 22 * (height / 32.0f) + 12) {
      r.setAction(2);
    }
    
    // Proportion sliders
    // Reset all
    // 30*-9, s24
    if(clickpos.x >= (width / 32.0f)
    && clickpos.y >= 30 * (height / 32.0f) - 9.0f
    && clickpos.x <= ((width / 32.0f) + 80)
    && clickpos.y <= 30 * (height / 32.0f) + 24.0f) {
      headSlider.setFactor(0.0f);
      torsoSlider.setFactor(0.0f);
      armsSlider.setFactor(0.0f);
      legsSlider.setFactor(0.0f);
    }
    
    // Sliders
    if(headSlider.isMouseOver(clickpos))
      headSlider.setDragged(true);

    if(torsoSlider.isMouseOver(clickpos))
      torsoSlider.setDragged(true);

    if(armsSlider.isMouseOver(clickpos))
      armsSlider.setDragged(true);

    if(legsSlider.isMouseOver(clickpos))
      legsSlider.setDragged(true);
  }
  
  // MÉTODO: evalUnlick(clickpos)
  ///      Verifica quando o botão do mouse é solto dentro do painel e
  ///      realiza lógica de acordo.
  /// PARÂMETROS:
  ///      clickpos  Posição de soltura do clique.
  public void evalUnclick(vec2 clickpos)
  {
    headSlider.setDragged(false);
    torsoSlider.setDragged(false);
    armsSlider.setDragged(false);
    legsSlider.setDragged(false);
  }
  
  ///   MÉTODO: update()
  ///      Atualiza toda a lógica do painel, incluindo movimento.
  public void update()
  {  
    clamp(panel_xspeed, -5.0f, 5.0f);
    if(showing) {
      if(position.x < 0.0f) {
        panel_xspeed += panel_accel;
        position.x += panel_xspeed;
      }
      else {
        position.x = 0.0f;
        panel_xspeed = 0.0f;
      }
    }
    else {
      if(position.x > -width/2.0f) {
        panel_xspeed -= panel_accel;
        position.x += panel_xspeed;
      }
      else {
        position.x = -width/2.0f;
        panel_xspeed = 0.0f;
      }
    }
    
    headSlider.update();
    torsoSlider.update();
    armsSlider.update();
    legsSlider.update();
    
    r.setHeadFactor(headSlider.getFactor());
    r.setTorsoFactor(torsoSlider.getFactor());
    r.setArmsFactor(armsSlider.getFactor());
    r.setLegsFactor(legsSlider.getFactor());
    
    // The three dots on the menu button should rotate when the panel
    // opens.
    menu_button_angle = ((position.x + (width/2.0f)) / (width/2.0f))
                                  * -HALF_PI;
  }
  
  /// MÉTODO: draw()
  ///      Desenha o painel no local correto.
  public void draw()
  {
    textAlign(CENTER, CENTER);
    pushMatrix();
    translate(position.x, position.y);
    noStroke();
    // Panel button
    fill(deep_orange);
    ellipse((width / 2.0f) + 30.0f, 30.0f, 50.0f, 50.0f);
    
    fill(text_icons);
    pushMatrix();
      translate((width / 2.0f) + 30.0f, 30.0f);
      rotate(menu_button_angle);
      ellipse(0.0f, -10.0f, 5.0f, 5.0f);
      ellipse(0.0f, 0.0f, 5.0f, 5.0f);
      ellipse(0.0f, 10.0f, 5.0f, 5.0f);
    popMatrix();
    
    // Panel background
    fill(text_icons);
    rect(-50, 0, (width / 2.0f) + 50.0f, height);
    
    // Panel headers
    fill(dark_red);
    rect(-50, 0, (width / 2.0f) + 50.0f, height / 20.0f);
    fill(red);
    rect(-50, (height / 20.0f), (width / 2.0f) + 50.0f, height / 5.0f);
    
    
    // Text
    textAlign(CENTER, CENTER);
    textSize(32);
    fill(text_icons);
    text("Preferências", (width / 4.0f), 3 * (height / 20.0f));
    
    
    // First section: Misc
    textAlign(LEFT, CENTER);
    textSize(16);
    fill(primary_text);
    text("Variados", (width / 32.0f), 9 * (height / 32.0f));
    fill(secondary_text);
    textSize(14);
    text("Mostrar robô", (width / 32.0f), 10 * (height / 32.0f));
    text("Mostrar esqueleto", (width / 32.0f), 11 * (height / 32.0f));
    
    // Checkboxes, first section
    ellipse((width / 64.0f), 10 * (height / 32.0f) + 2, 15.0f, 15.0f);
    ellipse((width / 64.0f), 11 * (height / 32.0f) + 2, 15.0f, 15.0f);
    fill(text_icons);
    if(r.getVisible())
      ellipse((width / 64.0f), 10 * (height / 32.0f) + 2, 10.0f, 10.0f);
    if(r.getVisibleJoints())
      ellipse((width / 64.0f), 11 * (height / 32.0f) + 2, 10.0f, 10.0f);
    
    // Divider
    stroke(divider);
    line(-10, 12 * (height / 32.0f), (width / 2.0f) - 1.0f,
                            12 * (height / 32.0f));
    noStroke();
    
    // Second section: Colors
    textAlign(LEFT, CENTER);
    textSize(16);
    fill(primary_text);
    text("Cores", (width / 32.0f), 13 * (height / 32.0f));
    
    
    // Android Green
    fill(android_green);
    ellipse((width / 32.0f) + 10.0f, 14 * (height / 32.0f) + 8.0f, 30.0f,
                                    30.0f);
    
    // Water Green
    fill(water_green);
    ellipse((width / 32.0f) + 44.0f, 14 * (height / 32.0f) + 8.0f, 30.0f,
                                    30.0f);
    
    // Purple
    fill(purple);
    ellipse((width / 32.0f) + 80.0f, 14 * (height / 32.0f) + 8.0f, 30.0f,
                                    30.0f);
    
    // Royal Red
    fill(royal_red);
    ellipse((width / 32.0f) + 115.0f, 14 * (height / 32.0f) + 8.0f, 30.0f,
                                    30.0f);
    
    // Yellow
    fill(yellow);
    ellipse((width / 32.0f) + 150.0f, 14 * (height / 32.0f) + 8.0f, 30.0f,
                                    30.0f);
    
    // Pink
    fill(pink);
    ellipse((width / 32.0f) + 185.0f, 14 * (height / 32.0f) + 8.0f, 30.0f,
                                    30.0f);
    
    // Marine Blue
    fill(marine_blue);
    ellipse((width / 32.0f) + 220.0f, 14 * (height / 32.0f) + 8.0f, 30.0f,
                                    30.0f);
    
    // Baby Blue
    fill(baby_blue);
    ellipse((width / 32.0f) + 255.0f, 14 * (height / 32.0f) + 8.0f, 30.0f,
                                    30.0f);
    
    // Orange
    fill(orange);
    ellipse((width / 32.0f) + 290.0f, 14 * (height / 32.0f) + 8.0f, 30.0f,
                                    30.0f);
    
    // Divider
    stroke(divider);
    line(-10, 16 * (height / 32.0f), (width / 2.0f) - 1.0f,
                            16 * (height / 32.0f));
    noStroke();
    
    // Third section: Outfits
    textAlign(LEFT, CENTER);
    textSize(16);
    fill(primary_text);
    text("Acessórios", (width / 32.0f), 17 * (height / 32.0f));
    
    fill(light_primary);
    rect((width / 32.0f) - 5.0f, 18 * (height / 32.0f) - 9.0f, 70.0f, 24.0f);
    fill(secondary_text);
    text("Chapéu", (width / 32.0f), 18 * (height / 32.0f));
    
    fill(light_primary);
    rect(90 + (width / 32.0f) - 5.0f, 18 * (height / 32.0f) - 9.0f, 70.0f,
                                    24.0f);
    fill(secondary_text);
    text("Relógio", 90 + (width / 32.0f), 18 * (height / 32.0f));
    
    fill(light_primary);
    rect(180 + (width / 32.0f) - 5.0f, 18 * (height / 32.0f) - 9.0f, 70.0f,
                                    24.0f);
    fill(secondary_text);
    text("Sapatos", 180 + (width / 32.0f), 18 * (height / 32.0f));
    
    fill(light_primary);
    rect(270 + (width / 32.0f) - 5.0f, 18 * (height / 32.0f) - 9.0f, 65.0f,
                                    24.0f);
    fill(secondary_text);
    text("Óculos", 270 + (width / 32.0f), 18 * (height / 32.0f));
    
    // Highlight acessories that are onscreen
    stroke(deep_orange);
    strokeWeight(2);
    // Hat
    if(r.getHatVisible())
      line((width / 32.0f) - 5.0f, 18 * (height / 32.0f) + 12,
       (width / 32.0f) + 62.0f, 18 * (height / 32.0f) + 12);
    // Clock
    if(r.getClockwatchVisible())
      line((width / 32.0f) + 90.0f - 5.0f, 18 * (height / 32.0f) + 12,
       (width / 32.0f) + 90.0f + 62.0f, 18 * (height / 32.0f) + 12);
    // Shoes
    if(r.getShoesVisible())
      line((width / 32.0f) + 180.0f - 5.0f, 18 * (height / 32.0f) + 12,
       (width / 32.0f) + 180.0f + 62.0f, 18 * (height / 32.0f) + 12);
    // Glasses
    if(r.getGlassesVisible())
      line((width / 32.0f) + 270.0f - 5.0f, 18 * (height / 32.0f) + 12,
       (width / 32.0f) + 270.0f + 62.0f, 18 * (height / 32.0f) + 12);
    strokeWeight(1);
    
    // Divider
    stroke(divider);
    line(-10, 20 * (height / 32.0f), (width / 2.0f) - 1.0f,
                            20 * (height / 32.0f));
    noStroke();
    
    // Fourth section: Animations
    textAlign(LEFT, CENTER);
    textSize(16);
    fill(primary_text);
    text("Animações", (width / 32.0f), 21 * (height / 32.0f));
    
    fill(light_primary);
    rect((width / 32.0f) - 5.0f, 22 * (height / 32.0f) - 9.0f, 77.0f,
                                    24.0f);
    fill(secondary_text);
    text("Nenhum", (width / 32.0f), 22 * (height / 32.0f));
    fill(light_primary);
    rect(6*(width / 32.0f) - 5.0f, 22 * (height / 32.0f) - 9.0f, 65.0f,
                                    24.0f);
    fill(secondary_text);
    text("Acenar", 6*(width / 32.0f), 22 * (height / 32.0f));
    fill(light_primary);
    rect(11*(width / 32.0f) - 5.0f, 22 * (height / 32.0f) - 9.0f, 65.0f,
                                    24.0f);
    fill(secondary_text);
    text("Dançar", 11*(width / 32.0f), 22 * (height / 32.0f));
    
    // Select current animation.
    stroke(deep_orange);
    float anim_s_pos;
    float anim_s_size;
    switch(r.getAction()) {
    default:
      anim_s_pos = 1.0f;
      anim_s_size = 65.0f;
      break;
    case 1: // Wave
      anim_s_pos = 6.0f;
      anim_s_size = 55.0f;
      break;
    case 2: // Dance
      anim_s_pos = 11.0f;
      anim_s_size = 55.0f;
      break;
    }
    strokeWeight(2);
    line(anim_s_pos*(width / 32.0f), 22 * (height / 32.0f) + 12,
       anim_s_pos*(width / 32.0f) + anim_s_size,
                           22 * (height / 32.0f) + 12);
    strokeWeight(1);
    
    // Divider
    stroke(divider);
    line(-10, 23 * (height / 32.0f), (width / 2.0f) - 1.0f,
                            23 * (height / 32.0f));
    noStroke();
    
    // Fifth section: Proportions
    textAlign(LEFT, CENTER);
    textSize(16);
    fill(primary_text);
    text("Proporções", (width / 32.0f), 24 * (height / 32.0f));
    
    // Fields
    fill(secondary_text);
    text("Cabeça", (width / 32.0f), 25 * (height / 32.0f));
    text("Torso", (width / 32.0f), 26 * (height / 32.0f));
    text("Braços", (width / 32.0f), 27 * (height / 32.0f));
    text("Pernas", (width / 32.0f), 28 * (height / 32.0f));
    
    // Scrolling bars
    headSlider.draw();
    torsoSlider.draw();
    armsSlider.draw();
    legsSlider.draw();
    
    // Reset button
    fill(light_primary);
    rect((width / 32.0f) - 5.0f, 30 * (height / 32.0f) - 9.0f, 80.0f, 24.0f);
    fill(secondary_text);
    text("Redefinir", (width / 32.0f), 30 * (height / 32.0f));
    
    // Divider
    stroke(divider);
    line(-10, 31 * (height / 32.0f), (width / 2.0f) - 1.0f,
                            31 * (height / 32.0f));
    noStroke();
    
    // End with a light primary color rectangle
    fill(light_primary);
    rect(-10.0f, 31 * (height / 32.0f) + 1, (width / 2.0f) + 10.0f,
                    height - (31 * (height / 32.0f)) + 1);
    
    // FPS Counter
    fill(text_icons);
    textSize(12.0f);
    text("FPS: " + frameRate, 6.0f, 12.0f);
    popMatrix();
  }
}

/// INSTÂNCIA: robotTest
///        Robô a ser desenhado na tela.
AndroidRobot robotTest;
/// INSTÂNCIA: panel
///        Painel a ser desenhado na tela.
Panel panel;

///  FUNÇÃO: setup()
///      Função padrão de pré-configuração do Processing.
void setup()
{
  // ALL YOUR GPU ARE BELONG TO US!!
  //size(1280, 720, OPENGL);
  //size(1920, 1080, OPENGL);
  
  // Ou use renderização por software se você é bobão.
  // ANDROID MODE: For optimal image quality, use P2D
  // rendering, not OpenGL.
  //size(1280, 720);
  
  // For lower resolutions, use this.
  size(800, 600);
  
  // ANDROID MODE: When running on Android, optimal framerate
  // is 30FPS. Comment out the 60FPS statement and uncomment
  // the 30FPS onee.
  frameRate(60);
  //frameRate(30);
  
  // ANDROID MODE: Use this when running as an android app.
  orientation(LANDSCAPE);
  
  robotTest = new AndroidRobot(new vec2(3*width/4.0f, (height/2.0f) + 50.0f));
  panel = new Panel(robotTest);
}

///  FUNÇÃO: draw()
///      Função padrão de desenho do Processing.
void draw()
{
  background(0);
  // Reposition robot according to panel
  robotTest.setPosition(
        new vec2((panel.getPosition().x + (width/2.0f) + width) / 2.0f,
                                           (height/2.0f) + 50.0f));
  //--
  robotTest.update();
  robotTest.draw();
  panel.update();
  panel.draw();
}

/// FUNÇÃO: mousePressed()
///      Verifica o pressionamento de botão do mouse.
///      Neste caso, repassa os cliques para que o painel os gerencie
///      de acordo.
void mousePressed()
{
        // ANDROID MODE: When running on android, mouseButton
        // does not exist. Just comment out the brackets and
        // the evaluation, and leave the panel.evalClick call.
  if(mouseButton == LEFT) {
    panel.evalClick(new vec2(mouseX, mouseY));
  }
}

/// FUNÇÃO: mousePressed()
///      Verifica a soltura do pressionamento de botão do mouse.
///      Neste caso, repassa os cliques para que o painel os gerencie
///      de acordo.
void mouseReleased()
{
        // ANDROID MODE: When running on android, mouseButton
        // does not exist. Just comment out the brackets and
        // the evaluation, and leave the panel.evalClick call.
  if(mouseButton == LEFT) {
    panel.evalUnclick(new vec2(mouseX, mouseY));
  }
}

/// FUNÇÃO: keyPressed()
///      Verifica o pressionamento de teclas.
///      O uso do teclado não é ideal neste programa, mas o uso de ESC
///      dará um sinal de saída, enquanto ESPAÇO e ENTER alterarão a
///      visibilidade do painel.
void keyPressed() {
  if(key == CODED) {
    if(keyCode == ESC)
      exit();
  }
  if(key == ' ' || key == '\n')
    panel.togglePanel();
}