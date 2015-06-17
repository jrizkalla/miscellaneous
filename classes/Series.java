package classes;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.Scanner;

public class Series {
	private String name;
	private int noOfEpisodes;
	private int noOfEpisodesDecreased;
	private boolean episodes [];
	private static Scanner fileReader;
	private static boolean firstObject = true;
	public enum readOption {read_from_file};
	//Constructors
		//Series (Series.readOption.read_from_file) reads the 
		//class properties from a save file (using the read()) method
		public Series (readOption choice){
			if (choice == readOption.read_from_file){
				boolean success = read(this);
				if (!success){
					name = "nameNotInitialized";
					noOfEpisodes = 50;
					noOfEpisodesDecreased = 49;
					episodes = new boolean [noOfEpisodes];
					for (int i = 0; i< noOfEpisodes; i++){
						episodes[i]= false;
					}
				}
			}
		}
		public Series (){
			name = "nameNotInitialized";
			noOfEpisodes = 50;
			noOfEpisodesDecreased = 49;
			episodes = new boolean [noOfEpisodes];
			for (int i = 0; i< noOfEpisodes; i++){
				episodes[i]= false;
			}
		}
		public Series (int noOfEpisodes){
			name = "nameNotInitialized";
			if (noOfEpisodes<0||noOfEpisodes>50){
				System.out.println("Error in the number of episodes passed");
				this.noOfEpisodes = 50;
			}
			else{
				this.noOfEpisodes = noOfEpisodes;
			}
			noOfEpisodesDecreased = (noOfEpisodes-1);
			episodes = new boolean [this.noOfEpisodes];
		}
		public Series (String name){
			this.name = name;
			noOfEpisodes = 50;
			noOfEpisodesDecreased = 49;
			episodes = new boolean [noOfEpisodes];
		}
		public Series(String name, int noOfEpisodes){
			this.name = name;
			if (noOfEpisodes<0||noOfEpisodes>50){
				System.out.println("Error in the number of episodes passed");
				this.noOfEpisodes = 50;
			}
			else{
				this.noOfEpisodes = noOfEpisodes;
			}
			episodes = new boolean [this.noOfEpisodes];
			noOfEpisodesDecreased = --(noOfEpisodes);
			for (int i = 0; i< this.noOfEpisodes; i++){
				episodes[i]= false;
			}
		}
	//end Of constructors
	//returns true if it read and false if it did not read anything 
	public static boolean read (Series readSeries){ 
		if (firstObject){
			try{
				fileReader = new Scanner (new File ("ASD150.txt"));
			} catch (FileNotFoundException e) {
				try {
					PrintStream CreateFile = new PrintStream ("ASD150.txt");
					CreateFile.print("132435465768798");
					return false;
				} catch (FileNotFoundException e1) {
					System.out.println("Error: ASD150.txt is unreachable");
					return false;
				}
			}
			firstObject = false;
		}
		String name = fileReader.nextLine();
		if (name.equals("132435465768798")){
			return false;
		}
		else{
			readSeries.name = name;
			readSeries.noOfEpisodes = fileReader.nextInt();
			readSeries.episodes = new boolean [readSeries.noOfEpisodes];
			readSeries.noOfEpisodesDecreased = (readSeries.noOfEpisodes - 1);
			for (int i = 0; i<readSeries.noOfEpisodes; i++){
				readSeries.episodes[i] = fileReader.nextBoolean();
			}
			return true;
		}
	}
	static public void save(ArrayList<Series> seriesToSave){
		try {
			PrintStream save = new PrintStream ("ASD150.txt");
			int noOfSeries = seriesToSave.size();
			Series tempSeries;
			for (int i = 0; i<noOfSeries; i++){
				tempSeries = seriesToSave.get(i);
				save.println(tempSeries.name);
				save.println(tempSeries.noOfEpisodes);
				for (int j = 0; j<tempSeries.noOfEpisodes; j++){
					save.println(tempSeries.episodes[j]);
				}
				if (i == (noOfSeries-1))
					save.println("132435465768798");
			}
			save.close();
		} catch (Exception e) {
			System.out.println("File is unreachable");
		}
	}
	public void watchedEpisode (int episodeWatched){
		episodeWatched--;
		if (episodeWatched < 0 || episodeWatched>noOfEpisodes){
			System.out.println("value passed is out of range");
			return;
		}
		episodes[episodeWatched]= true;
		}
	public void didNotWatchEpisode (int episodeWatched){
		episodeWatched--;
		if (episodeWatched < 0 || episodeWatched > noOfEpisodes){
			System.out.println("value passed is out of range");
			return;
		}
		episodes[episodeWatched] = false;
	}
	//Functions that access the class' methods
		public String getName (){return name;}
		public int getNoOfEpisodes(){return noOfEpisodes;}
		public boolean episodeWatched (int noOfEpisode){
			noOfEpisode--;
			if (noOfEpisode < 0|| noOfEpisode >noOfEpisodesDecreased){
				System.out.println("Value passed to episodesWatched(int) is out of range");
				return false;}
			else{
				return episodes[noOfEpisode];
			}
		}
	//end of functions
}
