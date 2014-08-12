/*

 BookMark - Wireless solution for libraries
 Brought to you by ~ StellarDimensions
 
 v 0.0.2 - August, 2014
 
 */

import controlP5.*;
import de.bezier.data.sql.*;
import de.bezier.data.sql.mapper.*;
import javax.swing.*;
import processing.serial.*;

ControlP5 cp5;
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
MySQL msql;
String fullRFID;
int i;
PImage logo;

void setup() {
  size(1100, 640);
  noStroke();
  //value = new String[4];
  i=0;
  fullRFID = new String(); 
  val= new String();
  String portname= Serial.list()[0];
  myPort= new Serial(this, portname, 9600);

  logo = loadImage("bookmark logo.png");

  PFont font = createFont("Cambria", 18);
  cp5 = new ControlP5(this);

  ControlFont labelFont = new ControlFont(createFont("Verdana", 11));
  cp5.setControlFont(labelFont);
  cp5.setColorLabel(color(255));



  String user     = "root";
  String pass     = "";

  String database = "library_db";

  msql = new MySQL( this, "localhost", database, user, pass );

  //  if (msql.connect())
  //  {
  //    print("database connected");
  //  }
  // By default all controllers are stored inside Tab 'default' 

  cp5.addTab("return")
    .setColorBackground(color(#2F86A0))
      .setColorLabel(color(255))
        .setColorActive(color(#4CC7EA))
          ;


  cp5.addTab("borrow")
    .setColorBackground(color(#2F86A0))
      .setColorLabel(color(255))
        .setColorActive(color(#4CC7EA))
          ;

  // if you want to receive a controlEvent when
  // a  tab is clicked, use activeEvent(true)

  cp5.getTab("default")
    .setColorBackground(color(#2F86A0))
      .setColorLabel(color(255))
        .setColorActive(color(#4CC7EA))
          .activateEvent(true)
            .setLabel("User Confirmation")
              .setHeight(60)
                .setWidth(160)
                  .setId(1)
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
                    ;

  cp5.getTab("return")
    .activateEvent(true)
      .setLabel("Return Books")
        .setHeight(60)
          .setWidth(160)
            .setId(2)
            .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
              ;

  cp5.getTab("borrow")
    .activateEvent(true)
      .setLabel("Borrow Books")
        .setHeight(60)
          .setWidth(160)
            .setId(3)
            .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
              ;
  // end of tabs

  // now the datafields
  // for the user

  cp5.addTextfield("userid")
    .setLabel("")
      .setPosition(400, 90)
        .setSize(300, 30)
          .setFont(font)
            .setFocus(true)
              .setColor(color(255))
                .setAutoClear(false)
                  ;


  cp5.addButton("clear1")
    .setPosition(420, 140)
      .setSize(120, 40)
        .setLabel("clear")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ;   

  cp5.addButton("manual_query")
    .setPosition(560, 140)
      .setSize(120, 40)
        .setLabel("Manual Query")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ; 


  cp5.addButton("next1")
    .setPosition(width-80, 290)
      .setSize(60, 160)
        .setLabel("next")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ; 

  // now for the return of books tab

  cp5.addTextfield("bookidreturn")
    .setPosition(400, 90)
      .setSize(300, 30)
        .setLabel("")
          .setFont(font)
            .setColor(color(255, 255, 255))
              .setAutoClear(false)
                ;

  cp5.addButton("clear2")
    .setPosition(350, 140)
      .setSize(120, 40)
        .setLabel("clear")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ;   


  cp5.addButton("manual_query2")
    .setPosition(490, 140)
      .setSize(120, 40)
        .setLabel("Manual Query")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ; 

  cp5.addButton("accept2")
    .setPosition(630, 140)
      .setSize(120, 40)
        .setLabel("Accept Book")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ; 

  cp5.addButton("clear_dues")
    .setPosition(width-150, 290)
      .setSize(60, 160)
        .setLabel("clear"+'\n'+" dues")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ; 

  cp5.addButton("next2")
    .setPosition(width-80, 290)
      .setSize(60, 160)
        .setLabel("next")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ; 


  // now for the borrow tab


  cp5.addTextfield("bookidborrow")
    .setPosition(400, 90)
      .setSize(300, 30)
        .setLabel("")
          .setFont(font)
            .setColor(color(255, 255, 255))
              .setAutoClear(false)
                ;

  cp5.addButton("clear3")
    .setPosition(350, 140)
      .setSize(120, 40)
        .setLabel("clear")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ;  

  cp5.addButton("manual_query3")
    .setPosition(490, 140)
      .setSize(120, 40)
        .setLabel("Manual Query")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ;  
  cp5.addButton("accept3")
    .setPosition(630, 140)
      .setSize(120, 40)
        .setLabel("Accept Book")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ; 

  cp5.addButton("next3")
    .setPosition(width-80, 290)
      .setSize(60, 160)
        .setLabel("next")
          .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
            ; 


  // arrange controller in separate tabs

  cp5.getController("bookidreturn").moveTo("return");
  cp5.getController("clear2").moveTo("return");
  cp5.getController("manual_query2").moveTo("return");
  cp5.getController("accept2").moveTo("return");
  cp5.getController("clear_dues").moveTo("return");
  cp5.getController("next2").moveTo("return");


  cp5.getController("bookidborrow").moveTo("borrow");
  cp5.getController("clear3").moveTo("borrow");
  cp5.getController("manual_query3").moveTo("borrow");
  cp5.getController("accept3").moveTo("borrow");
  cp5.getController("next3").moveTo("borrow");




  background(color(250));
  image(logo, width-250, 0);

  fill(color(40));
  rect(0, 60, width, 160);

  fill(color(0));
  rect(0, height-120, width, 120);


  fill(color(255));
  text("Summary", 40, height-90);
}

void draw() {

  if (cp5.window(this).currentTab().name()=="default")
  {
    if ( myPort.available() > 0) 
    {  // If data is available,
      val = myPort.readStringUntil('\n');
      println(val);
      fullRFID+=val;
      i++;
      if (i==4)
      {
        fullRFID=fullRFID.replace('\n', ' ');
        cp5.get(Textfield.class, "userid").setText(fullRFID);
        String sql="SELECT name, no_of_books_taken, due_fine FROM users WHERE user_rfid =  '%s' ; ";
        println(sql);
        msql.query( sql, fullRFID);

        if (msql.next())
        {
          //println(msql.getString(1));
          //          cp5.get(Textfield.class, "Name").setText(msql.getString(1));
          fullRFID="";
          fill(color(0));
          text("Name : "+msql.getString(1)+"\n"+"Books Borrowed : "+msql.getInt(2)+"\n"+ "Fines Incurred : " + msql.getString(3), 120, 260);
          i=0;
        }
      }
    }
  } else if (cp5.window(this).currentTab().name()=="return")
  {
    //image(books,40,200);
    if ( myPort.available() > 0) 
    {  // If data is available,
      val = myPort.readStringUntil('\n');
      println(val);
      fullRFID+=val;
      i++;
      if (i==4)
      {
        fullRFID=fullRFID.replace('\n', ' ');
        cp5.get(Textfield.class, "bookidreturn").setText(fullRFID);
        String sql="SELECT b.title, a.name, p.name, b.total_copies, b.borrowed_copies FROM copies c, books b, written_by w, authors a, publishers p WHERE c.copy_rfid =  '%s' AND c.book_id = b.book_id AND b.book_id = w.book_id AND w.author_id = a.author_id AND b.publisher_id = p.publisher_id ;";
        println(sql);
        msql.query( sql, fullRFID);
        if (msql.next())
        {
          println(msql.getString(1));
          cp5.get(Textfield.class, "BookName").setText(msql.getString(1));
          fullRFID="";
          fill(color(0));
          int height=220;
          int width=200;
          text("Book Title : "+msql.getString(1), width, height);
          text("Author : "+msql.getString(2), width, height+40);
          text("Publisher : "  + msql.getString(3), width, height+80);
          text("Available Copies : " + (msql.getInt(4)-msql.getInt(5)), width, height+120);

          //text("Book Title : "+msql.getString(1)+"\n"+"Author : "+msql.getString(2)+"\n"+  + "\n" +"Available Copies : " + (msql.getInt(4)-msql.getInt(5)),120,260);
          i=0;
        }
      }
    }
  } else
  {
    //image(books,40,200);
  }
}

void controlEvent(ControlEvent theControlEvent) {
  background(color(250));
  image(logo, width-250, 0);

  fill(color(40));
  rect(0, 60, width, 160);

  fill(color(0));
  rect(0, height-120, width, 120);


  fill(color(255));
  text("Summary", 40, height-90);
}


public void manual_query() {
  background(color(250));
  image(logo, width-250, 0);

  fill(color(40));
  rect(0, 60, width, 160);

  fill(color(0));
  rect(0, height-120, width, 120);


  fill(color(255));
  text("Summary", 40, height-90);

}

public void accept2() {
  background(color(250));
  image(logo, width-250, 0);

  fill(color(40));
  rect(0, 60, width, 160);

  fill(color(0));
  rect(0, height-120, width, 120);


  fill(color(255));
  text("Summary", 40, height-90);
  cp5.getTab("borrow").bringToFront();
}



public void clear1() {
  cp5.get(Textfield.class, "userid").clear();
  // also clear the variable hloding the user rfid here
}
public void clear2() {
  cp5.get(Textfield.class, "bookidreturn").clear();
}
public void clear3() {
  cp5.get(Textfield.class, "bookidborrow").clear();
}

public void next1() {
  cp5.getTab("return").bringToFront();
}
public void next2() {
  cp5.getTab("borrow").bringToFront();
}
public void next3() {
  cp5.getTab("default").bringToFront();
}




void keyPressed() {
  if (keyCode==TAB) {

    println(cp5.getController("userid").isVisible());
  }
}

/*
a list of all methods available for the Tab Controller
 use ControlP5.printPublicMethodsFor(Tab.class);
 to print the following list into the console.
 
 You can find further details about class Tab in the javadoc.
 
 Format:
 ClassName : returnType methodName(parameter type)
 
 controlP5.Tab : String getStringValue() 
 controlP5.Tab : Tab activateEvent(boolean) 
 controlP5.Tab : Tab bringToFront() 
 controlP5.Tab : Tab moveTo(ControlWindow) 
 controlP5.Tab : Tab setActive(boolean) 
 controlP5.Tab : Tab setHeight(int) 
 controlP5.Tab : Tab setLabel(String) 
 controlP5.Tab : Tab setValue(float) 
 controlP5.Tab : Tab setWidth(int) 
 controlP5.Tab : float getValue() 
 controlP5.ControllerGroup : CColor getColor() 
 controlP5.ControllerGroup : ControlWindow getWindow() 
 controlP5.ControllerGroup : ControlWindowCanvas addCanvas(ControlWindowCanvas) 
 controlP5.ControllerGroup : Controller getController(String) 
 controlP5.ControllerGroup : ControllerProperty getProperty(String) 
 controlP5.ControllerGroup : ControllerProperty getProperty(String, String) 
 controlP5.ControllerGroup : Label getCaptionLabel() 
 controlP5.ControllerGroup : Label getValueLabel() 
 controlP5.ControllerGroup : PVector getPosition() 
 controlP5.ControllerGroup : String getAddress() 
 controlP5.ControllerGroup : String getInfo() 
 controlP5.ControllerGroup : String getName() 
 controlP5.ControllerGroup : String getStringValue() 
 controlP5.ControllerGroup : String toString() 
 controlP5.ControllerGroup : Tab add(ControllerInterface) 
 controlP5.ControllerGroup : Tab bringToFront() 
 controlP5.ControllerGroup : Tab bringToFront(ControllerInterface) 
 controlP5.ControllerGroup : Tab close() 
 controlP5.ControllerGroup : Tab disableCollapse() 
 controlP5.ControllerGroup : Tab enableCollapse() 
 controlP5.ControllerGroup : Tab getTab() 
 controlP5.ControllerGroup : Tab hide() 
 controlP5.ControllerGroup : Tab moveTo(ControlWindow) 
 controlP5.ControllerGroup : Tab moveTo(PApplet) 
 controlP5.ControllerGroup : Tab open() 
 controlP5.ControllerGroup : Tab registerProperty(String) 
 controlP5.ControllerGroup : Tab registerProperty(String, String) 
 controlP5.ControllerGroup : Tab remove(CDrawable) 
 controlP5.ControllerGroup : Tab remove(ControllerInterface) 
 controlP5.ControllerGroup : Tab removeCanvas(ControlWindowCanvas) 
 controlP5.ControllerGroup : Tab removeProperty(String) 
 controlP5.ControllerGroup : Tab removeProperty(String, String) 
 controlP5.ControllerGroup : Tab setAddress(String) 
 controlP5.ControllerGroup : Tab setArrayValue(float[]) 
 controlP5.ControllerGroup : Tab setColor(CColor) 
 controlP5.ControllerGroup : Tab setColorActive(int) 
 controlP5.ControllerGroup : Tab setColorBackground(int) 
 controlP5.ControllerGroup : Tab setColorForeground(int) 
 controlP5.ControllerGroup : Tab setColorLabel(int) 
 controlP5.ControllerGroup : Tab setColorValue(int) 
 controlP5.ControllerGroup : Tab setHeight(int) 
 controlP5.ControllerGroup : Tab setId(int) 
 controlP5.ControllerGroup : Tab setLabel(String) 
 controlP5.ControllerGroup : Tab setMouseOver(boolean) 
 controlP5.ControllerGroup : Tab setMoveable(boolean) 
 controlP5.ControllerGroup : Tab setOpen(boolean) 
 controlP5.ControllerGroup : Tab setPosition(PVector) 
 controlP5.ControllerGroup : Tab setPosition(float, float) 
 controlP5.ControllerGroup : Tab setStringValue(String) 
 controlP5.ControllerGroup : Tab setUpdate(boolean) 
 controlP5.ControllerGroup : Tab setValue(float) 
 controlP5.ControllerGroup : Tab setVisible(boolean) 
 controlP5.ControllerGroup : Tab setWidth(int) 
 controlP5.ControllerGroup : Tab show() 
 controlP5.ControllerGroup : Tab update() 
 controlP5.ControllerGroup : Tab updateAbsolutePosition() 
 controlP5.ControllerGroup : boolean isCollapse() 
 controlP5.ControllerGroup : boolean isMouseOver() 
 controlP5.ControllerGroup : boolean isMoveable() 
 controlP5.ControllerGroup : boolean isOpen() 
 controlP5.ControllerGroup : boolean isUpdate() 
 controlP5.ControllerGroup : boolean isVisible() 
 controlP5.ControllerGroup : boolean setMousePressed(boolean) 
 controlP5.ControllerGroup : float getValue() 
 controlP5.ControllerGroup : float[] getArrayValue() 
 controlP5.ControllerGroup : int getHeight() 
 controlP5.ControllerGroup : int getId() 
 controlP5.ControllerGroup : int getWidth() 
 controlP5.ControllerGroup : void remove() 
 java.lang.Object : String toString() 
 java.lang.Object : boolean equals(Object) 
 
 
 */

