Guy [] guys;
Food [] foods;
PFont font;
int births,deaths;

void setup()
{
  //size(screen.width,screen.height);
  size(800,600);
  guys = new Guy[200];
  foods = new Food[10];
  for(int i = 0; i < foods.length; i++)
  {
    foods[i] = new Food();
  }
  for(int i = 0; i < guys.length; i++)
  {
    guys[i] = new Guy();
    guys[i].ix = width/2;
    guys[i].iy = height/2;
    guys[i].desire = 1;
    guys[i].findFood(foods);
  }
  
  font = createFont("AndaleMono",32);
  
  
  background(0);
}

void draw()
{
  //background(0);
  noStroke();
  fill(0,10);
  rectMode(CORNER);
  rect(0,0,width,height);
  //background(0);
  
  for(int i = 0; i < foods.length; i++)
  {
    foods[i].go();
  }
  
  for(int i = 0; i < guys.length; i++)
  {
    guys[i].go(foods);
    if(!guys[i].alive && guys[i].deathTimer <= 0 && guys.length > 1)
    {
      Guy [] clean = new Guy[guys.length-1];
      int itr = 0;
      for(int g = 0; g < guys.length; g++)
      {
        if(i != g)
        {
          clean[itr] = guys[g];
          itr++;
        }
      }
      guys = clean;
      deaths++;
      i--;
    }
  }
  
  //println(guys[0].hunger);
  rectMode(CENTER);
  stroke(255,0,0);
  noFill();
  //rect(foods[guys[0].food].x,foods[guys[0].food].y,25,25);
  //rect(guys[0].x,guys[0].y,25,25);
  rectMode(CORNER);
  stroke(255);
  fill(50);
  String infoString = "Guys: "+guys.length+"\t\tBirths: "+births+"\t\tDeaths: "+deaths;
  rect(6,height-24,infoString.length()*10,18);
  fill(255);
  textFont(font,14);
  text(infoString,8,height-10);
}

class Food
{
  int x,y;
  int amnt;
  Food()
  {
    x = int(random(width));
    y = int(random(height));
    amnt = 20;
  }
  void go()
  {
    if(amnt <= 0)
    {
        amnt = 0;
        relocate();
    }
    noStroke();
    fill(255,150,50);
    rectMode(CENTER);
    rect(x,y,amnt/10,amnt/10);
  }
  void relocate()
  {
    x = int(random(width));
    y = int(random(height));
    amnt = 20;
  }
}

class Guy
{
  float x,y;
  float ix,iy;
  int desire;
  int hunger;
  int clock;
  float dir;
  int food = -1;
  int birth = 0;
  int deathTimer = 500;
  boolean alive = true;
  Guy()
  {
    x = int(random(10000))%width;
    y = int(random(10000))%height;
  }
  Guy(float tx, float ty)
  {
    x = tx;
    y = ty;
  }
  void findFood(Food [] foodList)
  {
    float furthest = 9999999;
    for(int i = 0; i < foodList.length; i++)
    {
      if(foodList[i].amnt > 0)
      {
          float distInst = PVector.dist(new PVector(x,y),new PVector(foodList[i].x,foodList[i].y));
          if(distInst < furthest)
          {
            food = i;
            ix = foodList[i].x;
            iy = foodList[i].y;
            furthest = distInst;
          }
      }
    }
  }
  void checkValues()
  {
    desire = (desire < 0)?(0):(desire);
    desire = (desire > 17)?(17):(desire);
    
    hunger = (hunger < 1)?(1):(hunger);
    hunger = (hunger > 19)?(19):(hunger);
  }
  void go(Food [] foodList)
  {
    if(alive)
    {
      checkValues();
      dir = random(0.0,360.0);
  
      if(clock%(20-hunger) == 0)
      {
        desire = (int(random(1000))%2 == 0)?(desire+1):(desire);
      }
      
      if(clock%100 == 0)
      {
        hunger = (int(random(1000))%2 == 0)?(hunger+1):(hunger);
      }
      
      if(clock%(20-desire) == 0 && desire != 0)
      {
        dir = degrees(atan2(x-ix,y-iy));
        
        if(abs(ix-x) < 2.0 && abs(iy-y) < 2.0)
        {
          if(abs(foodList[food].x-x) < 2.0 && abs(foodList[food].y-y) < 2.0 && foodList[food].amnt > 0)
          {
            foodList[food].amnt -= 5;
            hunger -= 10;
            desire  = 0;
            birth++;
          }
          else
          {
            findFood(foodList);
          }
        }
      }
      
      if(hunger >= 19)
      {
        alive = false;
      }
      
      if(birth >= 19 && alive)
      {
        Guy clone = new Guy(x,y);
        clone.findFood(foodList);
        guys = (Guy[]) append(guys,clone);
        birth = 0;
        hunger += 3;
        births++;
      }
      /*
      1  2  3
      
      0  x  4
      
      7  6  5
      */
      
      x += sin(radians(dir-180));
      y += cos(radians(dir-180));
      
      x = (x < 0)?(0):(x);
      x = (x > width)?(width):(x);
      y = (y < 0)?(0):(y);
      y = (y > height)?(height):(y);
    }
    
    noStroke();
    if(!alive)
    {
      fill(150,100,75);
      deathTimer--;
    }
    else
    {
      fill(255);
    }
    rectMode(CORNER);
    rect(x,y,1,1);
    
    clock++;
    clock = clock%1000;
  }
}
