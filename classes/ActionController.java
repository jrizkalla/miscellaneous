package classes;

import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;
import java.awt.event.WindowEvent;
import java.util.ArrayList;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;

public class ActionController extends JFrame implements ActionListener, 
	ItemListener, MouseMotionListener{
	private static final long serialVersionUID = 1L;
	//f is user to keep track of the "episodesLabel"'s created
	static int f = 0;
	//d determines the location of the "episodesLabel"'s created
	//x starts with 175 and with each button adds 30 to d
	static int d = 175;
	static int e = 2;
	//makes sure that the "popUpFrame" is constructed only once
	static boolean popUpFrameConstructed = false;
	//makes sure that the "typeSeriesName" does not clear every time
	//the mouse is moved over it
	static boolean clearTextBox = true;
	static boolean Continue;
	
	//This method controls the clicking of the buttons
	@Override
	public void actionPerformed(ActionEvent event) {
		//determine which button is pressed
		int buttonPressed = 0;
		//event.getSource() tells which button is pressed
		if (event.getSource().equals(Display.enterButton))
			buttonPressed = 1;
		if (event.getSource().equals(Display.watchNextEpisode))
			buttonPressed = 2;
		if (event.getSource().equals(Display.createSeriesButton))
			buttonPressed = 3;
		if (event.getSource().equals(Display.cancelButton))
			buttonPressed = 4;
		for (int i = 0, j = 5; i<10; i++, j++){
			//loop for 10 times
			if (event.getSource().equals(Display.episodesLabel[i]))
				buttonPressed = j;
				//if the button is equal to "episodesLabel" [i]
				//then set the "buttonPressed" to j
		}
		
		switch (buttonPressed){
		//act according to the button pressed
			case 1:
				//"enterButton" clicked in the "popUpFrame"
				//call "enterButtonClicked()"
				enterButtonClicked();
				break;
			case 2:
				//"watchNextEpisode" clicked in the "mainFrame"
				if (f > 9){
				//if there is 10 "episodeLabel"'s
					//then deactivate the watchNextEpisode button
					//and exit the case
					Display.watchNextEpisode.setEnabled(false);
					break;
				}
				String theNextEpisode = null;
				//get (from the series) the first unwatched episode
				for (int i = 1; i<=Display.mainSeries.getNoOfEpisodes(); i++){
				//loop until i = the number of episodes
					if (!(Display.mainSeries.episodeWatched(i))){
					//if episode i is not watched
						//add to the String "theNextEpisode"
						//and change the episode to watched in 
						//the "mainSeries"
						theNextEpisode = (""+i);
						Display.mainSeries.watchedEpisode(i);
						break;
					}	
				}
				if (theNextEpisode == null){
				//if all episodes are watched then deactivate the
				//watchNextEpisode button
					Display.watchNextEpisode.setEnabled(false);
					break;
				}
				Display.refreshMainFrame();
				//create the button with text from the comboBox
				Display.setEpisodesLabel(f, theNextEpisode );
				//set the bounds according to d
				Display.episodesLabel[f].setBounds(d,24,20,15);
				//add "episodesLabel"[f] to "objectsHolder1"
				Display.objectsHolder1.add(Display.episodesLabel[f]);
				Display.refreshMainFrame();
				//create a temporary ArrayList that to pass it to the save()
				//method in the Series class
				ArrayList<Series> tempArrayList= new ArrayList<Series> ();
				//add the "mainSeries" to the "tempArrayList"
				tempArrayList.add(Display.mainSeries);
				//save the "mainSeries"
				Series.save(tempArrayList);
				//increment f and e, and add 30 to d
				f++;
				e++;
				d += 30;
				break;
			case 3:
				//"createNewSeries" button clicked in the "mainFrame"
				//enable the "popUpFrame" and disable the "mainFrame"
				Display.popUpFrame.setEnabled(true);
				Display.mainFrame.setEnabled(false);
				//set the text of the text box
				Display.typeSeriesName.setText("Type name and season here");
				//make sure that the text box is cleared when the mouse is moved
				clearTextBox = true;
				if (!popUpFrameConstructed){
				//if (the popUpFrame is not Constructed
					//construct it by calling "addObjectsToObjectsHolder2()"
					Display.addObjectsToObjectsHolder2();
					popUpFrameConstructed = true;
				}
				//make the pop up frame visible
				Display.popUpFrame.setVisible(true);
				break;
			case 4:
				//"cancelButton" clicked in the "popUpFrame"
				//refresh the mainFrame, enable it, and make sure
				//its visible
				Display.refreshMainFrame();
				Display.mainFrame.setEnabled(true);
				Display.mainFrame.setVisible(true);
				Display.mainFrame.requestFocus();
				//hide the popUpFrame
				Display.popUpFrame.setVisible(false);
				break;
			case 5:
				deleteTheLabel (1);
				break;
			case 6:
				deleteTheLabel (2);
				break;
			case 7:
				deleteTheLabel (3);
				break;
			case 8:
				deleteTheLabel (4);
				break;
			case 9:
				deleteTheLabel (5);
				break;
			case 10:
				deleteTheLabel (6);
				break;
			case 11:
				deleteTheLabel (7);
				break;
			case 12:
				deleteTheLabel (8);
				break;
			case 13:
				deleteTheLabel (9);
				break;
			case 14:
				deleteTheLabel (10);
				break;
		}
	}

	//This method controls when the combo box is clicked
	@Override
	public void itemStateChanged(ItemEvent arg0) {
		if (Display.mainComboBox.getSelectedItem().equals("Choose an episode")||
				Display.mainComboBox.getSelectedItem().equals("(Empty)")){
		//if the user didn't choose an item (stuck on default) or if 
		//the combo box is empty
			//exit
			return;
		}
		else{
			//then continue...
			Continue = true;
			Display.refreshMainFrame();
			//get the selected item from the menu and change it from 'Episode 00' to '00'
			String selectedItem = shortenString((String) 
					Display.mainComboBox.getSelectedItem());
			for (int i = 0; i<f && e%2 == 0 && e<22;i++){
			//loop if i is less than f (no of "episodeLabel"'s) produced
			//and less than 10 (e fixes a technical problem with the itemStateChanged
				if (Display.episodesLabel[i].getText().equals(selectedItem)||
						selectedItem.equals("(Empty)")){
				//if the selected item is already created or if it is equal to "(Empty)"
					//don't continue and exit the loop
					Continue = false;
					break;}
				else
					Continue = true;
			}
			//fix a technical error and make sure that the user does not
			//choose an option more than 10 times
			if (e%2 == 0&& e<22 && Continue){
				Display.refreshMainFrame();
				//create the button with text from the comboBox
				Display.setEpisodesLabel(f, selectedItem );
				Display.episodesLabel[f].setBounds(d,24,20,15);
				Display.objectsHolder1.add(Display.episodesLabel[f]);
				Display.refreshMainFrame();
				Display.mainSeries.watchedEpisode(changeStringToNumber(selectedItem));
				ArrayList<Series> tempArrayList= new ArrayList<Series> ();
				tempArrayList.add(Display.mainSeries);
				Series.save(tempArrayList);
				Display.mainFrame.setVisible(true);
				f++;
				d += 30;
			}
			e++;
		}
	}
	
	//change a string from "Episode 00" to "00"
	public String shortenString (String temp){
		for (int i =0 ; i<51; i++){
			if (temp.equals("Episode "+i))
				return (""+i);
			else
				continue;
		}
		return "";
	}
	
	//changes a string to a number
	public static int changeStringToNumber(String stringNumber){
		 return (Integer.parseInt(stringNumber));
	}
	static void resetMainFrame(){
		f = 0;
		e = 2;
		d = 175;
		Display.addObjectsToObjectHolder1();
		Display.mainFrame.setEnabled(true);
		Display.mainFrame.requestFocus();
	}
	
	static void enterButtonClicked (){
		Display.popUpFrame.setEnabled(false);
		int controller = 
		JOptionPane.showConfirmDialog(null, "If you save all your previous data will be lost\n"+
		"Do you want to save anyway", "Save", 1);
		switch (controller){
			case 0:
				//"yes"
				String stringNumber = (String)Display.episodesNo1.getSelectedItem();
				int episodesNumber;
				if (stringNumber.equals("No."))
					episodesNumber = 0;
				else
					episodesNumber = changeStringToNumber(stringNumber) * 10;
				stringNumber = (String)Display.episodesNo2.getSelectedItem();
				if (stringNumber.equals("No."))
					episodesNumber +=0;
				else
					episodesNumber += (changeStringToNumber((String)Display.episodesNo2.getSelectedItem()));
				
				Display.mainSeries = new Series(Display.typeSeriesName.getText(),
						episodesNumber);
				Display.typeSeriesName.setText("Type name and season here");
				ArrayList<Series> tempArrayList= new ArrayList<Series> ();
				tempArrayList.add(Display.mainSeries);
				Series.save(tempArrayList);
				resetMainFrame();
				WindowEvent windowEvent1 = new WindowEvent(Display.mainFrame, WindowEvent.WINDOW_CLOSING);
                Toolkit.getDefaultToolkit().getSystemEventQueue().postEvent(windowEvent1);
				WindowEvent windowEvent2 = new WindowEvent(Display.popUpFrame, WindowEvent.WINDOW_CLOSING);
                Toolkit.getDefaultToolkit().getSystemEventQueue().postEvent(windowEvent2);
				return;
				//break;
			case 1:
				//"no"
				Display.refreshMainFrame();
				Display.mainFrame.setEnabled(true);
				Display.mainFrame.requestFocus();
				Display.popUpFrame.setVisible(false);
				break;
			case 2:
				//"cancel"
				Display.popUpFrame.setEnabled(true);
				Display.popUpFrame.requestFocus();
				break;
		}
	}
	
	static void deleteTheLabel (int no){
		e -= 2;
		d = 175;
		no --;
		Display.mainSeries.didNotWatchEpisode(changeStringToNumber(
				Display.episodesLabel[no].getText()));
		ArrayList<Series> temp = new ArrayList<Series> ();
		temp.add(Display.mainSeries);
		Series.save(temp);
		for (int i = 0; i<f; i++){
			Display.objectsHolder1.remove(Display.episodesLabel[i]);
		}
		Display.episodesLabel [no] = new JButton("");
		for (int i = (no+1); i<(f); i++){
			Display.episodesLabel[(i-1)] = Display.episodesLabel[i];
		}
		for (int i = 0; i<(f-1); i++){
			Display.episodesLabel[i].setBounds(d,24,20,15);
			d += 30;
		}
		for (int i = 0; i< (f-1); i++){
			Display.objectsHolder1.add(Display.episodesLabel[i]);
		}
		Display.watchNextEpisode.setEnabled(true);
		Display.refreshMainFrame();
		Display.mainFrame.requestFocus();
		f--;
	}

	@Override
	public void mouseDragged(MouseEvent arg0) {	
	}

	@Override
	public void mouseMoved(MouseEvent arg0) {
		if(clearTextBox){
			Display.typeSeriesName.setText("");
			clearTextBox = false;
		}

	}


}
