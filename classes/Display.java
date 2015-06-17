package classes;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Toolkit;
import java.util.ArrayList;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.border.LineBorder;

public class Display {
	
	
	static Color backgroundColor = new Color (222,237,245);
	static Color fontColor = new Color (0, 87, 131);
	static Color buttonsColor = new Color(139,211,247);
	static Series mainSeries = new Series(Series.readOption.read_from_file);
	static JPanel welcomeMessageHolder = new JPanel();
	static JPanel objectsHolder1 = new JPanel ();
	static JPanel objectsHolder2 = new JPanel ();
	static JFrame popUpFrame = new JFrame ("Episoder: new Series");
	static JFrame mainFrame = new JFrame ();
	static JComboBox mainComboBox = new JComboBox();
	static JComboBox episodesNo1 = new JComboBox();
	static JComboBox episodesNo2 = new JComboBox();
	static JButton enterButton = new JButton("Enter");
	static JButton watchNextEpisode = new JButton ("Watch the next Episode");
	static JButton createSeriesButton = new JButton ("New Series");
	static JButton cancelButton = new JButton ("Cancel"	);
	static JButton episodesLabel [] = new JButton [10];
	static JLabel welcomeMessage = new JLabel ("Episoder V.1.1");
	static JLabel loadingMessage = new JLabel ("Loading...");
	static JLabel productionInfo = new JLabel ("July 2012");
	static JLabel productionInfo2 = new JLabel ("Produced by John Rizkalla");
	static JLabel instruction1 = new JLabel ("Watch: ");
	static JLabel instrutcion2 = new JLabel ("Episodes to watch: ");
	static JLabel PUInstruction1 = new JLabel ("Series name: ");
	static JLabel PUInstruction2 = new JLabel ("Ex: Example, Season 1");
	static JLabel PUNoOfEpisodes = new JLabel ("Number of episodes: ");
	static Font labelFont = new Font("Gill Sans MT", Font.BOLD, 16);
	static String optionsInMenu []= new String [10];
	static ArrayList<String> optionsInComboBox = new ArrayList<String>();
	static ArrayList<JLabel> contInst2 = new ArrayList<JLabel>();
	static JTextField typeSeriesName = new JTextField("Type name and season here", 50);
	static ActionController actionController = new ActionController();
	
	
	
	
	
	public Display (){	
		displayWelcomeMessage();
		addObjectsToObjectHolder1();
		mainFrame.setSize(500,220);
		controlAppearancePlace(mainFrame, 250, 150);
		mainFrame.setVisible(true);
	}
	
	private static void controlAppearancePlace(JFrame frame, int xDec, int yDec){
	//controls the position of the frame on the screen
		//get the dimension of the screen
		Dimension dimOfScreen = Toolkit.getDefaultToolkit().getScreenSize();
		//get the x and y dimensions from dimOfScreen
		int x = (int) (dimOfScreen.getWidth()/2);
		int y = (int)(dimOfScreen.getHeight()/2);
		//subtract the values passed from x and y
		x-= xDec;y-= yDec;
		//sets the location of the frame according to the new x and y
		frame.setLocation(x,y);
	}
	
	static public void addObjectsToObjectHolder1(){
	//adds all required objects to "ObjectsHolder1" (JPanel) and adds
	//"objectsHolder1" to the "mainFrame"
		//makes the "mainFrame" invisible and makes it exit with the x button
		mainFrame.setVisible(false);
		mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		//if there is no file or if the info. saved on the file is the default 
		//it sets the title of the "mainFrame" to "Episoder"
		//if the name is initialized it sets it to "Episoder-" + title of series
		if (mainSeries.getName().equals("nameNotInitialized"))
			mainFrame.setTitle("Episoder");
		else
			mainFrame.setTitle("Episoder-"+mainSeries.getName());
		
		objectsHolder1.setBackground(backgroundColor);
		//set the layout to nothing so that it does not put the default layout
		objectsHolder1.setLayout(null);
		//adds the first option of the combo box to the ArrayList "optionsInComboBox"
		optionsInComboBox.add("Choose an episode");
		//add all the unwatched episodes to the arrayList "optionsInComboBox"
		if (!((mainSeries.getName()).equals("nameNotInitialized"))){
			//if the series name is not equals to 'nameNotInitialized'
			//go into a loop
			for (int i = 1; i<=mainSeries.getNoOfEpisodes(); i++){
				//loop until the number of loops is equal to the no of episodes
				//in the series
				//if the episode (i) is not watched...
				if (!(mainSeries.episodeWatched(i))){
						//add the number of episodes to "optionsInComboBox" next to the 
						//word 'Episode '
						optionsInComboBox.add("Episode "+i);
				}
				else
					continue;
			}
		}
		//If nothing was added to "optionsInTheComboBox" it adds '(Empty)'
		//and disables the watchNextEpisode button
		if (optionsInComboBox.size() == 1){
			optionsInComboBox.add("(Empty)");
			watchNextEpisode.setEnabled(false);
		}
		//sets the "mainComboBox" (the combo box that contains the
		//episodes)
		mainComboBox.setBackground(new Color(192,219,233));
		//								grey-blue
		mainComboBox.setForeground(fontColor);
		mainComboBox.setFont(new Font("Gill Sans MT", Font.PLAIN, 15));
		//add the class that responds to action ("actionController" object)
		mainComboBox.addItemListener(actionController);
		//adds the items from "optionsInComboBox" arrayList to the "mainComboBox"
		for (int i = 0; i<optionsInComboBox.size(); i++){
			mainComboBox.addItem(optionsInComboBox.get(i));
		}
	
		//sets "instruction1" ('Watch: ')
		instruction1.setForeground(fontColor);
		instruction1.setFont(labelFont);
		//fontColor and labelFont are defined above
		
		//sets "instruction2" ('Episodes to watch: ')
		//sets the text that appears when the user points the mouse on the
		//label
		instrutcion2.setToolTipText("The episodes you're going to watch");
		instrutcion2.setForeground(fontColor);
		instrutcion2.setFont(labelFont);
		
		//sets the "watchNextEpisode" button
		watchNextEpisode.setForeground(fontColor);
		watchNextEpisode.requestFocus();
		watchNextEpisode.setFont(new Font("Gill Sans MT", Font.PLAIN, 16));
		//make it work with the enter button
		mainFrame.getRootPane().setDefaultButton(watchNextEpisode);
		watchNextEpisode.addActionListener(actionController);
		
		//sets the "createSeriesButton"
		createSeriesButton.setBackground(buttonsColor);
		createSeriesButton.setForeground(Color.black);
		createSeriesButton.setFont(new Font("Gill Sans MT", Font.PLAIN, 16));
		createSeriesButton.addActionListener(actionController);
		
		//set the location and size of all the components on "objectsHolder1"
		instruction1.setBounds(80, 55, 100, 20);
		//                    (x, y, width, height)
		mainComboBox.setBounds(140, 55, 200, 20);
		instrutcion2.setBounds(30,20,145,20);
		watchNextEpisode.setBounds(100,100,195,25);
		createSeriesButton.setBounds(300,100,110,25);
		
		//add the stuff to "objectsHolder1"
		//validate () makes sure that it is writable
		objectsHolder1.validate();
		objectsHolder1.add(instrutcion2);
		objectsHolder1.add(instruction1);
		objectsHolder1.add(mainComboBox);
		objectsHolder1.add(watchNextEpisode);
		objectsHolder1.add(createSeriesButton);
		
		//if the name is not initialized (nothing in the combo
		//box and the "watchNextEpisode" button won't work)...
		if (mainSeries.getName().equals("nameNotInitialized")){
			//deactivate everything except the "createSeriesButton"
			instrutcion2.setEnabled(false);
			instruction1.setEnabled(false);
			mainComboBox.setEnabled(false);
			watchNextEpisode.setEnabled(false);
		}
		//adds "objectsHolder1" to the "mainFrame" and makes
		//the "mainFrame" visible
		mainFrame.add(objectsHolder1);
		mainFrame.setVisible(true);
	}
	
	void displayWelcomeMessage(){
		//makes the mainFrame invisible
		mainFrame.setVisible(false);
		//set the mainFrame in the center, controls the size, 
		//sets the title, make it unclosable, and set the
		//layout of the "welcomeMessageHolder" (JPanel)to nothing 
		//(not the default layout)
		controlAppearancePlace(mainFrame, 200, 150);
		mainFrame.setSize(400,200);
		mainFrame.setTitle("Episoder V.1.1");
		mainFrame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
		welcomeMessageHolder.setLayout(null);
		
		//sets the welcomeMessage ('Episoder V.1.1')
		welcomeMessage.setFont(new Font("Gill Sans MT", Font.BOLD, 30));
		welcomeMessage.setForeground(fontColor);
		
		//sets the "productInfo" (date of production)
		productionInfo.setFont(new Font("Gill Sans MT", Font.PLAIN, 10));
		productionInfo.setForeground(Color.black);

		//sets the "productInfo2" ('Produced by John Rizkalla')
		productionInfo2.setFont(new Font("Gill Sans MT", Font.PLAIN, 10));
		productionInfo2.setForeground(Color.black);
		
		//sets the "loadingMessage" ('Loading...')
		loadingMessage.setFont(labelFont);
		loadingMessage.setForeground(Color.black);
		
		//sets the location and size of the components
		welcomeMessage.setBounds(87,5,400,100);
		//                      (x, y, width, height)
		productionInfo.setBounds(170,130,50,10);
		productionInfo2.setBounds(135,140,150,10);
		loadingMessage.setBounds(150,80,100,20);
		
		//adds everything to "welcomeMessageHolder"
		welcomeMessageHolder.add(welcomeMessage);
		welcomeMessageHolder.add(loadingMessage);
		welcomeMessageHolder.add(productionInfo);
		welcomeMessageHolder.add(productionInfo2);
		
		//adds the "wecomeMessageHolder" to the "mainFrame" and
		//makes the "mainFrame" visible
		mainFrame.add(welcomeMessageHolder);
		mainFrame.setVisible(true);
		
		//waits for 3 seconds (3000 milliseconds)
		try {
			Thread.sleep(3000);
		} catch (InterruptedException e) {System.out.println("interupted");}
		
		//makes the "mainFrame" invisible and removes the "welcomeMessageHolder"
		mainFrame.setVisible(false);
		mainFrame.remove(welcomeMessageHolder);
	}

	static void addObjectsToObjectsHolder2(){
		//makes the "mainFrame" invisible
		mainFrame.setVisible(false);
		//sets the appearance place of the "popUpFrame", 
		//makes it unclosable, and sets it's size
		controlAppearancePlace(popUpFrame, 250, 150);
		popUpFrame.setDefaultCloseOperation(JFrame.DO_NOTHING_ON_CLOSE);
		popUpFrame.setSize(500,200);
		//               (width,height)
		
		//set the layout of "objectsHoler2" (JPanel) to nothing
		objectsHolder2.setLayout(null);
		objectsHolder2.setBackground(backgroundColor);
		
		//adds the word 'No.' to "episodesNo1" and "EpisodesNo2" (JComboBox)
		episodesNo1.addItem("No.");
		episodesNo2.addItem("No.");
		for (int i = 0; i<10; i++){
		//loops for 10 times
			//as long as "i" is less than 5...
			if (i<5)
				episodesNo1.addItem(""+i);
				//adds "i" (as a String form) to the first combo box ("episodesNo1")
			episodesNo2.addItem(""+i);
			//adds all the numbers from 0-9 to the second combo box ("episodesNo2")
		}
		
		//sets "episodesNo1" and "episodesNo2"
		episodesNo1.setBackground(new Color(192,219,233));
		episodesNo1.setForeground(fontColor);
		episodesNo1.setFont(new Font("Gill Sans MT", Font.PLAIN, 15));
		episodesNo2.setBackground(new Color(192,219,233));
		episodesNo2.setForeground(fontColor);
		episodesNo2.setFont(new Font("Gill Sans MT", Font.PLAIN, 15));
		
		//sets "PUInstruction1" ('Series name: ')
		PUInstruction1.setForeground(fontColor);
		PUInstruction1.setFont(labelFont);
		//sets "PUNoOfEpisodes" ('Number of episodes: ')
		PUNoOfEpisodes.setForeground(fontColor);
		PUNoOfEpisodes.setFont(labelFont);
		//sets "PUInstruction2" ('Ex: Example, Season 1') 
		PUInstruction2.setForeground(Color.black);
		PUInstruction2.setFont(new Font("Gill Sans MT", Font.PLAIN, 12));
		//sets the enterButton and adds "actionController" (ActionController object)
		//as the ActionListener
		enterButton.setForeground(fontColor);
		enterButton.setFont(new Font("Gill Sans MT", Font.PLAIN, 16));
		enterButton.addActionListener(actionController);
		//make it work with the enter button
		mainFrame.getRootPane().setDefaultButton(enterButton);
		enterButton.requestFocus();
		//set up the cancel button add "actionController" as the ActionListener
		cancelButton.setForeground(fontColor);
		cancelButton.setFont(new Font("Gill Sans MT", Font.PLAIN, 16));
		cancelButton.addActionListener(actionController);
		//sets up "typeSeriesName" (JTextBox) and puts a MouseMotionListener
		//(so that it erases the text when the mouse moves over it)
		typeSeriesName.setFont(new Font("Gill Sans MT", Font.PLAIN, 16));
		typeSeriesName.addMouseMotionListener(actionController);
		
		//sets the shape and size of the components
		PUInstruction1.setBounds(100,25,100, 20);
		//                    (x, y, width, height)
		typeSeriesName.setBounds(205,24, 200, 25);
		PUInstruction2.setBounds(220,45, 200, 20);
		PUNoOfEpisodes.setBounds(90,70,200,20);
		episodesNo1.setBounds(250,73,50,20);
		episodesNo2.setBounds(300,73,50,20);
		enterButton.setBounds(230,110,100,30);
		cancelButton.setBounds(350,110,100,30);
		
		//adds everything to "objectsHolder2"
		objectsHolder2.add(PUInstruction1);
		objectsHolder2.add(typeSeriesName);
		objectsHolder2.add(PUInstruction2);
		objectsHolder2.add(PUNoOfEpisodes);
		objectsHolder2.add(episodesNo1);
		objectsHolder2.add(episodesNo2);
		objectsHolder2.add(enterButton);
		objectsHolder2.add(cancelButton);
		
		//adds "objectsHolder2" to the "popUpFrame" and 
		//makes the "popUpFrame" visible
		popUpFrame.add(objectsHolder2);
		popUpFrame.setVisible(true);
	}
	
	static void setEpisodesLabel(int i, String text){
		//creates and object (JButton) for the labels (that
		//tell the user which episodes he/she watched
		episodesLabel[i]= new JButton(text);
		episodesLabel[i].setFont(labelFont);
		episodesLabel[i].setForeground(fontColor);
		episodesLabel[i].setBackground(new Color (183,223,246));
		//creates a border for the button
		episodesLabel[i].setBorder(new LineBorder(new Color (146,210,247)));
		//set the text to 'Click to cancel' when the mouse moves over the
		//button
		episodesLabel[i].setToolTipText("Click to cancel");
		//adds "actionController" as an ActionListener
		episodesLabel[i].addActionListener(actionController);
		//makes sure that it is accessible
		episodesLabel[i].setEnabled(true);
	}
	static void refreshMainFrame(){
		//refreshed the "mainFrame" and makes sure that it
		//is writable
		mainFrame.invalidate();
		mainFrame.validate();
		mainFrame.repaint();
	}
	static void refreshPopUpFrame(){
		//refreshed the "popUpFrame" and makes sure that it
		//is writable
		popUpFrame.invalidate();
		popUpFrame.validate();
		popUpFrame.repaint();
	}

}
