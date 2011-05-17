/*
			
			http://www.monocubed.com
			http://processingjs.org/
			
			*/
			
			
			/*
			notes:
			
			add preloader graphic - do a check at the start to see if everything has loaded first - if so show loaded and click here message to gain focus
			tweak titleScreen design
			*/
			
			
		
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			// 
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			/* @pjs preload="hero1.png,hero2.png,hero3.png,loading.png,loaded.png,arm.png, armFlash.png, ball1.png, ball2.png, ball3.png, ballFlash.png, cage1.png, cage2.png, cage3.png, cageFlash.png, dust1.png, dust2.png, dust3.png, heroFlash.png, labs.png, labsfront.png, laser.png,lives.png, lose.png,mini1.png, mini2.png, mini3.png, padlock.png, padlockFlash.png, rock1.png, rock2.png, rock3.png, rockFlash.png, spim1.png, spim2.png, spim3.png, spimFlash.png, virup0001.png,virup0002.png,virup0003.png, virupFlash.png, win.png ";*/
			
			int windowWidth = 960;
			int windowHeight = 540;
			
			//hero assets
			int heroNumFrames = 3;
			PImage[] hero = new PImage[heroNumFrames];
			
			int heroFrameCount = 0;
			int targetX = int(windowWidth/2);
			int targetY = 450;
			int heroOffsetX = int(159/2);
			int heroOffsetY = int(64/2);
			int heroBodyOffsetX = int(81/2);
			int heroBodyOffsetY = int(47/2);
			int heroX = targetX;
			int heroY = targetY;
			int heroGhostX;
			int heroGhostY;
			int ghostSpeed = 20;
			int heroSpeed = 10;
			int speedX = 100;
			int speedY = 100;
 
			int numStars = 30;
			int numLives = 5;
			int heroHealth = 100;
			boolean flashHero = false;
			int[][] starField = new int[numStars];
			
			boolean bossCreated = false;
			Boss inbox;
			Padlock padlockHeart;
			Arm leftArm;
			Arm rightArm;
			
			int dustCounter = 0;
			
			int dustCloudX;
			int dustCloudY;
			
			boolean heroDestroyed = false;
			
			boolean paused = false;
			
			boolean gameStarted = false;
			
			int gameStartTime = millis();
			
			int introDuration = 5000;
			
			boolean keysLocked = true;
			
			int timePaused;
			
			int timeAllEnemiesCleared;
			
			int points = 0;
			string ps;
			
			int lastLaserFired;
			
			boolean assetsPreloaded = false;
			boolean gameFocused = false;
			
			boolean mouseEnabled = false;
			
			//mini
			int miniNumFrames = 3;
			PImage[] mini = new PImage[miniNumFrames];
			ArrayList currentMini = new ArrayList();
			
			//spim assets
			int spimNumFrames = 3;
			PImage[] spim = new PImage[spimNumFrames];
			
			//virup assets
			int virupNumFrames = 3;
			PImage[] virup = new PImage[virupNumFrames];
			
			//rock assets
			int rockNumFrames = 3;
			PImage[] rock = new PImage[rockNumFrames];
			
			/* boss assets */
			
			//cage
			int cageNumFrames = 3;
			PImage[] cage = new PImage[cageNumFrames];
			
			//padlock
			int padlockNumFrames = 1;
			PImage[] padlock = new PImage[padlockNumFrames];
			
			//ball
			int ballNumFrames = 3;
			PImage[] ball = new PImage[ballNumFrames];
			
			//arm
			int armNumFrames = 1;
			PImage[] arm = new PImage[armNumFrames];
			
			//enemy type and time to create [skin, time, x, y, shield, flighttype]
			int[][] enemyArr = [
			
			
			
								[2, 7000, int(windowWidth/2), -50, 0, 0],
								[2, 8000, int(windowWidth/2), -50, 0, 0],
								[2, 9000, int(windowWidth/2), -50, 0, 0],
								[2, 10000, int(windowWidth/2), -50, 0, 0],
								
								[1, 13000, ((960/5)*1) + 7, -50, 0, 2],
								[1, 13300, ((960/5)*2) + 7, -50, 0, 2],
								[1, 13600, ((960/5)*3) + 7, -50, 0, 2],
								[1, 13900, ((960/5)*4) + 7, -50, 0, 2],
								
								[0, 20000, ((960/5)*1) + 7, -50, 1, 1],
								[0, 20000, ((960/5)*2) + 7, -50, 1, 1],
								[0, 20000, ((960/5)*3) + 7, -50, 1, 1],
								[0, 20000, ((960/5)*4) + 7, -50, 1, 1],
 
								[1, 25000, ((960/5)*1) + 7, -50, 1, 2],
								[1, 25300, ((960/5)*2) + 7, -50, 1, 2],
								[1, 25600, ((960/5)*3) + 7, -50, 1, 2],
								[1, 25900, ((960/5)*4) + 7, -50, 1, 2],
		
								[0, 30000, int(windowWidth/2), -50, 1, 0],
								[0, 32000, int(windowWidth/2), -50, 1, 0],
								[0, 34000, int(windowWidth/2), -50, 1, 0],
								[0, 36000, int(windowWidth/2), -50, 1, 0],
								
								[0, 40000, ((960/5)*1) + 7, -50, 1, 1],
								[1, 40000, ((960/5)*2) + 7, -50, 1, 1],
								[2, 40000, ((960/5)*3) + 7, -50, 1, 1],
								[0, 40000, ((960/5)*4) + 7, -50, 1, 1],
								
								[1, 45000, ((960/5)*1) + 7, -50, 1, 1],
								[0, 45000, ((960/5)*2) + 7, -50, 1, 1],
								[2, 45000, ((960/5)*3) + 7, -50, 1, 1],
								[1, 45000, ((960/5)*4) + 7, -50, 1, 1],
								
								[0, 49000, int(windowWidth/2), -50, 1, 0],
								[2, 50000, int(windowWidth/2), -50, 1, 0],
								[0, 51000, int(windowWidth/2), -50, 1, 0],
								[1, 52000, int(windowWidth/2), -50, 1, 0],
								[0, 53000, int(windowWidth/2), -50, 1, 0],
								[2, 54000, int(windowWidth/2), -50, 1, 0],
								[0, 55000, int(windowWidth/2), -50, 1, 0],
								[1, 56000, int(windowWidth/2), -50, 1, 0],
								
								[0, 58000, ((960/5)*4) + 7, -50, 1, 2],
								[0, 58300, ((960/5)*3) + 7, -50, 1, 2],
								[0, 58600, ((960/5)*2) + 7, -50, 1, 2],
								[0, 58900, ((960/5)*1) + 7, -50, 1, 2],
								
								[1, 61000, ((960/5)*1) + 7, -50, 1, 2],
								[1, 61300, ((960/5)*2) + 7, -50, 1, 2],
								[1, 61600, ((960/5)*3) + 7, -50, 1, 2],
								[1, 61900, ((960/5)*4) + 7, -50, 1, 2],
								
								[2, 64000, ((960/5)*4) + 7, -50, 1, 2],
								[2, 64300, ((960/5)*3) + 7, -50, 1, 2],
								[2, 64600, ((960/5)*2) + 7, -50, 1, 2],
								[2, 64900, ((960/5)*1) + 7, -50, 1, 2],
								
								[1, 67000, ((960/5)*1) + 7, -50, 1, 2],
								[2, 67300, ((960/5)*2) + 7, -50, 1, 2],
								[0, 67600, ((960/5)*3) + 7, -50, 1, 2],
								[1, 67900, ((960/5)*4) + 7, -50, 1, 2]
								
								];
							
			int enemyArrPointer = 0;
			ArrayList currentEnemies = new ArrayList();
			
			//laser assets
			PImage laser = new PImage();
			ArrayList currentLasers = new ArrayList();
			
			//lives assets
			PImage lives = new PImage();
			
			//labs asset
			PImage labs = new PImage();
			int labsY = windowHeight - 292;
			PImage labsfront = new PImage();
			int labsfrontY = 383;
			float takeoffSpeed = 0.0;
			float takeoffAcceleration = 0.2;
			
			//dust assets
			int dustNumFrames = 15;
			PImage dust = new PImage[dustNumFrames];
			ArrayList currentDust = new ArrayList();
			
			//win assets
			PImage lose = new PImage();
			int loseOffsetX = int(371/2);
			int loseOffsetY = int(119/2);
 
			//lose assets
			PImage win = new PImage();
			int winOffsetX = int(352/2);
			int winOffsetY = int(122/2);
			
			//title assets
			PImage title = new PImage();
			int titleOffsetX = int(671/2);
			int titleOffsetY = int(499/2);
			//
			int miniTitleFrameCount = 0;
			
			//loading asset
			PImage loading = new PImage();
			int loadingOffsetX = int(91/2);
			int loadingOffsetY = int(18/2);
			
			//loaded asset
			PImage loaded = new PImage();
			int loadedOffsetX = int(233/2);
			int loadedOffsetY = int(18/2);
			
			//load in the numbers for points
			PImage numbers = new PImage();
			//
			Array numberWidths = [14, 14, 14, 14, 14, 14, 14, 14, 14, 14];
			
			//assets
			ArrayList assetsList = new ArrayList();
 
			
			
			
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			// SETUP
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			void setup() {
				
				//environment setup
				size(windowWidth, windowHeight);
				background(250);
				frameRate(40);
				//noCursor();
				
				//
				gameStartTime = millis();
				
				//load in the image for loading
				loading = loadImage("loading.png?" + random());
				
				//load in the image for loaded
				loaded = loadImage("loaded.png?" + random());
				
				//load in the images for the hero
				for (int i=0; i<hero.length; i++) {
					String imageName = "hero" + (i+1) + ".png?" + random();
					hero[i] = loadImage(imageName);
					//assetsList.add(hero[i]);
				}
				hero[hero.length] = loadImage("heroFlash.png?" + random());
				//assetsList.add(hero[hero.length]);
				
				//load in the images for mini
				for (int i=0; i<mini.length; i++) {
					String imageName = "mini" + (i+1) + ".png?" + random();
					mini[i] = loadImage(imageName);
					//assetsList.add(mini[i]);
				}
				
				//load in the images for the spim
				for (int i=0; i<spim.length; i++) {
					String imageName = "spim" + (i+1) + ".png?" + random();
					spim[i] = loadImage(imageName);
					//assetsList.add(spim[i]);
				}
				spim[spim.length] = loadImage("spimFlash.png");
			    //assetsList.add(spim[spim.length]);
				
				//load in the images for the virup
				for (int i=0; i<virup.length; i++) {
					String imageName = "virup000" + (i+1) + ".png?" + random();
					virup[i] = loadImage(imageName);
					//assetsList.add(virup[i]);
				}
				virup[virup.length] = loadImage("virupFlash.png");
				//assetsList.add(virup[virup.length]);
				
				//load in the images for the rock
				for (int i=0; i<rock.length; i++) {
					String imageName = "rock" + (i+1) + ".png?" + random();
					rock[i] = loadImage(imageName);
					//assetsList.add(rock[i]);
				}
				rock[rock.length] = loadImage("rockFlash.png");
				//assetsList.add(rock[rock.length]);
				
				//load in the image for bullets
				laser = loadImage("laser.png?" + random());
				//assetsList.add(laser);
				
				//load in the images for dust
				for (int i=0; i<dust.length; i++) {
					String imageName = "dust" + (i+1) + ".png?" + random();
					dust[i] = loadImage(imageName);
					//assetsList.add(dust[i]);
				}
				
				//load in the image for win
				win = loadImage("win.png?" + random());
				//assetsList.add(win);
				
				
				//load in the image for lose
				lose = loadImage("lose.png?" + random());
				//assetsList.add(lose);
				
				//load in the image for the title
				title = loadImage("title.png?" + random());
				assetsList.add(title);
				
				//load in the image of labs
				labs = loadImage("labs.png?" + random());
				assetsList.add(labs);
				//load in the image of labsfront
				labsfront = loadImage("labsfront.png?" + random());
				assetsList.add(labsfront);
 
 
				//load in the images for the boss
				//cage
				for (int i=0; i<cage.length; i++) {
					String imageName = "cage" + (i+1) + ".png?" + random();
					cage[i] = loadImage(imageName);
					//assetsList.add(cage[i]);
				}
				cage[cage.length] = loadImage("cageFlash.png?" + random());
				//assetsList.add(cage[cage.length]);
				
				//padlock
				padlock[0] = loadImage("padlock.png");
				//assetsList.add(padlock[0]);
				padlock[1] = loadImage("padlockFlash.png");
				//assetsList.add(padlock[1]);
				
				//arm
				arm[0] = loadImage("arm.png");
				//assetsList.add(arm[0]);
				arm[1] = loadImage("armFlash.png");
				//assetsList.add(arm[1]);
				
				//ball
				for (int i=0; i<ball.length; i++) {
					String imageName = "ball" + (i+1) + ".png?" + random();
					ball[i] = loadImage(imageName);
					//assetsList.add(ball[i]);
				}
				ball[ball.length] = loadImage("ballFlash.png");
				//assetsList.add(ball[ball.length]);	
				
				//numbers
				for (int i=0; i<10; i++) {
					String  imageName = i + ".png?" + random();
					numbers[i] = loadImage(imageName);
					//assetsList.add(numbers[i]);
				}
 
				
				//load in the image of the lives
				lives = loadImage("lives.png?" + random());
				//assetsList.add(lives);
				
				//create a starfield
				for (int i=0; i<numStars; i++) {
					int rx = int(random(windowWidth));
					int ry = int(random(windowHeight));
					float rs = float(random(12)+7);
					int rr = int(random(5)+2);
					starField[i] = [rx, ry, rs, rr, 0.0];
				}
				
				
			}
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			// DRAW
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
 
			void draw() {
	
				//clear the background with space
				background(#1c232c);
				fill(255, 80);
				//stroke(#FFFFFF);
				noStroke();
				
				if (gameStarted) {
					if ((millis() - gameStartTime) > introDuration) {
						for (int i=0; i<numStars; i++) {
					
							//draw a point for the star
							//point(starField[i][0], starField[i][1]);
							ellipse(starField[i][0], starField[i][1], starField[i][3], starField[i][3]);
					
							//if stars actual speed is less than it's given potential speed - increment it
							if (starField[i][4] < starField[i][2]) {
								starField[i][4] += 0.3;
							}
							//increment the y pos of star by its speed
							starField[i][1] = starField[i][1] + starField[i][4];
					
							//if the star is off screen put it back to the top
							if (starField[i][1] > windowHeight) {
								starField[i][1] = 0;
							}
					
						}
				
					} else {
						for (int i=0; i<numStars; i++) {
					
							//draw a point for the star
							starField[i][4] = 0.0;
							ellipse(starField[i][0], starField[i][1], starField[i][3], starField[i][3]);
 
						}
					}
				} else {
					//render for the title screen
					for (int i=0; i<numStars; i++) {
 
						//increment the y pos of star by its potential speed
						starField[i][1] = starField[i][1] + starField[i][2];
						
						ellipse(starField[i][0], starField[i][1], starField[i][3], starField[i][3]);
						//if the star is off screen put it back to the top
						if (starField[i][1] > windowHeight) {
							starField[i][1] = 0;
						}
					
					}
				}
				
				//display loading and figure out if the assets have loaded
				//if not then we set gameStarted to false and return
				//we also need to lock the key presses until assets are loaded
				
				if (!assetsPreloaded) {
					assetsPreloaded = true;
					for (int i=0; i<assetsList.size(); i++) {
						if (assetsList[i].width < 2) {
							assetsPreloaded = false;
						}
					}
					image(loading, (windowWidth/2)-loadingOffsetX, (windowHeight/2)-loadingOffsetY);
					return;
				} else if (!gameFocused) {
					image(loaded, (windowWidth/2)-loadedOffsetX, (windowHeight/2)-loadedOffsetY);
					return;
				}
 
				
				/*
				if ((title.width < 2) || (labs.width <2)) {
					image(loading, (windowWidth/2)-loadingOffsetX, (windowHeight/2)-loadingOffsetY);
					assetsPreloaded = false;
					return;
				} else {
					assetsPreloaded = true;
				}
				*/
				
				
				
				if (!gameStarted) {
					//display the title
					displayTitle();
					//keep gameStartTime topped up
					gameStartTime = millis();
					return;
				}
				
				
				
				//start heroDestroyed
				if (!heroDestroyed) {
					
					//check to see if we should produce another enemy
					if (enemyArrPointer < enemyArr.length) {
						
						//create enemies
						if ((millis() - gameStartTime) > enemyArr[enemyArrPointer][1]) {
					
							//check to see what enemie we should create
							switch(enemyArr[enemyArrPointer][0]) {
								case 0:
									//create a new instance of spim
									s = new Spim(enemyArr[enemyArrPointer][2], enemyArr[enemyArrPointer][3], enemyArr[enemyArrPointer][4], enemyArr[enemyArrPointer][5]);
									//add it to the list of currentEnemies
									currentEnemies.add(s);
									break;
								case 1:
									//create a new instance of virup
									v = new Virup(enemyArr[enemyArrPointer][2], enemyArr[enemyArrPointer][3], enemyArr[enemyArrPointer][4], enemyArr[enemyArrPointer][5]);
									currentEnemies.add(v);
									break;
								case 2:
									//create a new instance of rock
									r = new Rock(enemyArr[enemyArrPointer][2], enemyArr[enemyArrPointer][3], enemyArr[enemyArrPointer][4], enemyArr[enemyArrPointer][5]);
									currentEnemies.add(r);
									break;
							}
					
							//increment enemyArrPointer
							if (enemyArrPointer < enemyArr.length) {
								enemyArrPointer++;
							}
							
						}
						//are we on the last wave?
						if (enemyArrPointer == enemyArr.length-1) {
							timeAllEnemiesCleared = millis();
						}
						
					} else if (!bossCreated) {
				
						//wait for a duration first
						if ((millis() - timeAllEnemiesCleared) > 10000) {
							//time to create the boss
							inbox = new Boss();
							//end of spawns
							bossCreated = true;
						}
					
					} else {
					
						if (!inbox.destroyed) {
								
							inbox.update();
 
							//check collision with cage
							int cageMinX = inbox.x - inbox.offsetX;
							int cageMaxX = inbox.x + inbox.offsetX;
							int cageMinY = inbox.y - inbox.offsetY;
							int cageMaxY = inbox.y + inbox.offsetY;
					
							if ((heroX + (heroBodyOffsetX/2) > cageMinX) && (heroX - (heroBodyOffsetX/2) < cageMaxX) && (heroY + (heroBodyOffsetY/2) > cageMinY) && (heroY - (heroBodyOffsetY/2) < cageMaxY)) {
					
						
								//flash hero
								flashHero = true;
		
								//deduct from health
								heroHealth -= 50;
								//if health has depleted we refresh health and deduct life
								if (heroHealth <= 0) {
									numLives -= 1;
									heroHealth = 0;
									if (numLives <= 0) {
										heroDestroyed = true;
									} else {
										heroHealth = 100;
 
										//add the dust	
										d = new Dust(heroX, heroY);
										currentDust.add(d);
								
										//reposition hero
										targetX = int(windowWidth/2);
										targetY = 400;
										heroX = targetX;
										heroY = windowHeight + 100;
									}
							
								}
 
							}
						}
					
						if (leftArm.destroyed && rightArm.destroyed) {
						
							//change flight pattern
							inbox.flight = 1;
						
							if (!padlockHeart.destroyed) {
						
								//check collision with the padlock
								//find out the bounding box of the enemy
								int padlockMinX = padlockHeart.x - padlockHeart.offsetX;
								int padlockMaxX = padlockHeart.x + padlockHeart.offsetX;
								int padlockMinY = padlockHeart.y - padlockHeart.offsetY;
								int padlockMaxY = padlockHeart.y + padlockHeart.offsetY;
							
								//go through all the lasers on screen
								for (int j=0; j<currentLasers.size(); j++) {
							
									//check to see if any of them are hitting the current enemy
									if ((currentLasers[j].x > padlockMinX) && (currentLasers[j].x < padlockMaxX) && (currentLasers[j].y > padlockMinY) && (currentLasers[j].y < padlockMaxY)) {
 
										//flash
										padlockHeart.flash();
								
										//remove the laser
										currentLasers.remove(j);
 
										if (padlockHeart.hits == padlockHeart.shield) {
								
								
											//add points
											points += padlockHeart.pointsPerKill;
								
											//add the dust	
											d = new Dust(padlockHeart.x, padlockHeart.y);
											currentDust.add(d);
											
											//flag as destroyed
											padlockHeart.destroyed = true;
 
										} else {
	
											//incremement hits
											padlockHeart.hits += 1;
									
										}
									}
								}
							} else {
							
								//change flight pattern for final time
								inbox.flight = 2;
							
							
								if (!inbox.destroyed) {
								
									int inboxMinX = inbox.x - inbox.offsetX;
									int inboxMaxX = inbox.x + inbox.offsetX;
									int inboxMinY = inbox.y - inbox.offsetY;
									int inboxMaxY = inbox.y + inbox.offsetY;
 
									//go through all the lasers on screen
									for (int j=0; j<currentLasers.size(); j++) {
 
										//check to see if any of them are hitting the current enemy
										if ((currentLasers[j].x > inboxMinX) && (currentLasers[j].x < inboxMaxX) && (currentLasers[j].y > inboxMinY) && (currentLasers[j].y < inboxMaxY)) {
 
											//flash
											inbox.flash();
											//add the dust	
										
											d = new Dust(currentLasers[j].x, currentLasers[j].y);
											currentDust.add(d);
 
											//remove the laser
											currentLasers.remove(j);
 
											if (inbox.hits == inbox.shield) {
												
												//flag as destroyed
												inbox.destroyed = true;
												dustCloudX = inbox.x;
												dustCloudY = inbox.y;
 
											} else {
 
												//incremement hits
												inbox.hits += 1;
 
											}
										}
									}
									
								} else {
 
						
									if (dustCounter < 200) {
										if ((dustCounter%2) == 0) {
											d = new Dust(dustCloudX + int(random()*200)-100 - inbox.offsetX, dustCloudY + int(random()*200) - inbox.offsetX);
											currentDust.add(d);
											//add points
											points += inbox.pointsPerKill;
		
										}
										if ((dustCounter%25) == 0) {
											//spawn mini gmails - give them random offset (which they will use in conjunction with heroX and heroY and random speeds to follow)
											m = new MiniG(dustCloudX-inbox.offsetX, dustCloudY, float(random()*30) + 110, int(random()*10) + 15, float(random()/30)+0.03);
											currentMini.add(m);
										}
										
										
										
										dustCounter++
									} else {
										displayWin();
									}
	
								}	
							}
						}
					
						//PHASE I
						//lasers or hero on the arms?
						if (!leftArm.destroyed) {
							//leftArm collision
							//find out the bounding box of the enemy
							int leftArmMinX = leftArm.x - leftArm.offsetX;
							int leftArmMaxX = leftArm.x + leftArm.offsetX;
							int leftArmMinY = leftArm.y - leftArm.offsetY;
							int leftArmMaxY = leftArm.y + leftArm.offsetY;
					
							//go through all the lasers on screen
							for (int j=0; j<currentLasers.size(); j++) {
								//check to see if any of them are hitting
								if ((currentLasers[j].x > leftArmMinX) && (currentLasers[j].x < leftArmMaxX) && (currentLasers[j].y > leftArmMinY) && (currentLasers[j].y < leftArmMaxY)) {
							
									//flash
									leftArm.flash();
							
									//remove the laser that killed the enemy
									currentLasers.remove(j);
							
							
									if (leftArm.hits == leftArm.shield) {
							
							
										//add points
										points += rightArm.pointsPerKill;
							
										//add the dust	
										d = new Dust(leftArm.x, leftArm.y);
										currentDust.add(d);
							
										//remove the enemy
										leftArm.destroyed = true;
 
									} else {
 
										//incremement hits
										leftArm.hits += 1;
								
									}
								}
							}
						
							//hero collision
							//check collision with hero
							if ((heroX + (heroBodyOffsetX/2) > leftArmMinX) && (heroX - (heroBodyOffsetX/2) < leftArmMaxX) && (heroY + (heroBodyOffsetY/2) > leftArmMinY) && (heroY - (heroBodyOffsetY/2) < leftArmMaxY)) {
						
							
								//flash hero
								flashHero = true;
			
								//deduct from health
								heroHealth -= 50;
								//if health has depleted we refresh health and deduct life
								if (heroHealth <= 0) {
									numLives -= 1;
									heroHealth = 0;
									if (numLives <= 0) {
										heroDestroyed = true;
									} else {
										heroHealth = 100;
								
										//add the dust	
										d = new Dust(heroX, heroY);
										currentDust.add(d);
 
										//reposition hero
										targetX = int(windowWidth/2);
										targetY = 400;
										heroX = targetX;
										heroY = windowHeight + 100;
								
										
									}
								}
								//retract arm
								leftArm.attackMode = false;
								leftArm.startTime = millis();
								
 
							}	
						}
					
						if (!rightArm.destroyed) {
							//leftArm collision
							//find out the bounding box of the enemy
							int rightArmMinX = rightArm.x - rightArm.offsetX;
							int rightArmMaxX = rightArm.x + rightArm.offsetX;
							int rightArmMinY = rightArm.y - rightArm.offsetY;
							int rightArmMaxY = rightArm.y + rightArm.offsetY;
					
							//go through all the lasers on screen
							for (int j=0; j<currentLasers.size(); j++) {
								//check to see if any of them are hitting
								if ((currentLasers[j].x > rightArmMinX) && (currentLasers[j].x < rightArmMaxX) && (currentLasers[j].y > rightArmMinY) && (currentLasers[j].y < rightArmMaxY)) {
							
									//flash
									rightArm.flash();
							
									//remove the laser that killed the enemy
									currentLasers.remove(j);
							
							
									if (rightArm.hits == rightArm.shield) {
							
										//add points
										points += rightArm.pointsPerKill;
							
										//add the dust	
										d = new Dust(rightArm.x, rightArm.y);
										currentDust.add(d);
							
										//remove the enemy
										rightArm.destroyed = true;
 
									} else {
 
										//incremement hits
										rightArm.hits += 1;
								
									}
								}
							}
						
							//hero collision
							//check collision with hero
							if ((heroX + (heroBodyOffsetX/2) > rightArmMinX) && (heroX - (heroBodyOffsetX/2) < rightArmMaxX) && (heroY + (heroBodyOffsetY/2) > rightArmMinY) && (heroY - (heroBodyOffsetY/2) < rightArmMaxY)) {
						
							
								//flash hero
								flashHero = true;
			
								//deduct from health
								heroHealth -= 50;
								//if health has depleted we refresh health and deduct life
								if (heroHealth <= 0) {
									numLives -= 1;
									heroHealth = 0;
									if (numLives <= 0) {
										heroDestroyed = true;
									} else {
										heroHealth = 100;
								
										//add the dust	
										d = new Dust(heroX, heroY);
										currentDust.add(d);
 
										//reposition hero
										targetX = int(windowWidth/2);
										targetY = 400;
										heroX = targetX;
										heroY = windowHeight + 100;
								
										
									}						
								}
								
								//retract arm
								rightArm.attackMode = false;
								rightArm.startTime = millis();
								
 
							}
						}
					}
									
					//go through all the enemies on screen
					for (int i=0; i<currentEnemies.size(); i++) {
					
						//update the position of the enemy
						currentEnemies[i].update();
						
						//check to see if the enemy is off screen
						if (currentEnemies[i].y > windowHeight + 50) {
							
							//if they are, then remove them
							currentEnemies.remove(i);
							
						} else {
							
							//find out the bounding box of the enemy
							int enemyMinX = currentEnemies[i].x - currentEnemies[i].offsetX;
							int enemyMaxX = currentEnemies[i].x + currentEnemies[i].offsetX;
							int enemyMinY = currentEnemies[i].y - currentEnemies[i].offsetY;
							int enemyMaxY = currentEnemies[i].y + currentEnemies[i].offsetY;
							
							//go through all the lasers on screen
							for (int j=0; j<currentLasers.size(); j++) {
								
								//check to see if any of them are hitting the current enemy
								if ((currentLasers[j].x > enemyMinX) && (currentLasers[j].x < enemyMaxX) && (currentLasers[j].y > enemyMinY) && (currentLasers[j].y < enemyMaxY)) {
									
									//flash
									currentEnemies[i].flash();
								
									//remove the laser that killed the enemy
									currentLasers.remove(j);
 
									if (currentEnemies[i].hits == currentEnemies[i].shield) {
								
								
										//add points
										points += currentEnemies[i].pointsPerKill;
								
										//add the dust	
										d = new Dust(currentEnemies[i].x, currentEnemies[i].y);
										currentDust.add(d);
									
										//remove the enemy
										currentEnemies.remove(i);
										
 
									} else {
	
										//incremement hits
										currentEnemies[i].hits += 1;
									
									}
								
								}
	
							}
							
							
							//check collision with hero
							if ((heroX + (heroBodyOffsetX/2) > enemyMinX) && (heroX - (heroBodyOffsetX/2) < enemyMaxX) && (heroY + (heroBodyOffsetY/2) > enemyMinY) && (heroY - (heroBodyOffsetY/2) < enemyMaxY)) {
						
								//add the dust	
								d = new Dust(currentEnemies[i].x, currentEnemies[i].y);
								currentDust.add(d);
							
								//remove the enemy
								currentEnemies.remove(i);
						
								//flash hero
								flashHero = true;
			
								//deduct from health
								heroHealth -= 34;
								//if health has depleted we refresh health and deduct life
								if (heroHealth <= 0) {
									numLives -= 1;
									heroHealth = 0;
									if (numLives <= 0) {
										heroDestroyed = true;
									} else {
										heroHealth = 100;
								
										//add the dust	
										d = new Dust(heroX, heroY);
										currentDust.add(d);
 
										//reposition hero
										targetX = int(windowWidth/2);
										targetY = 400;
										heroX = targetX;
										heroY = windowHeight + 100;
									}
								}
							}
							
						}
						
					
					}	
							
					//render the lasers
					for (int i=0; i<currentLasers.size(); i++) {
						currentLasers[i].update();
						if (currentLasers[i].y < 10) {
							currentLasers.remove(i);
						}
					}
				
					//render the dust
					for (int i=0; i<currentDust.size(); i++) {
						currentDust[i].update();
						if (currentDust[i].currentFrame == dustNumFrames) {
							currentDust.remove(i);
						}
					}
				
					//render the mini
					for (int i=0; i<currentMini.size(); i++) {
						currentMini[i].update();
					}
				
					//if we have paused for long enough, then start panning camera
					if ((millis() - gameStartTime) > introDuration) {
						if (labsY < windowHeight) {
							image(labs, 0, labsY);
							labsY += takeoffSpeed;
							takeoffSpeed+=takeoffAcceleration;
						}
						keysLocked = false;
						
					} else {
						//keep the camera where we are
						image(labs, 0, labsY);
						//stay low
						if ((millis() - gameStartTime) < introDuration - 3000) {
							targetY = 450;
						} else if ((millis() - gameStartTime) < introDuration - 1000) {
							targetY = 400;
						} else if ((millis() - gameStartTime) < introDuration - 000) {
							targetY = 300;
						}
						
					}
 
					//animate the frames of hero
					if (!flashHero) {
						int heroFrame = heroFrameCount % heroNumFrames;
					} else {
						int heroFrame = heroNumFrames;
						flashHero = false;
					}
					//draw and position hero
				
					if (mouseEnabled && !keysLocked) {
						heroX += ((mouseX - heroX)/heroSpeed);
						heroY += ((mouseY - heroY)/heroSpeed);
					} else {
						heroX += ((targetX - heroX)/heroSpeed);
						heroY += ((targetY - heroY)/heroSpeed);
					}
 
					image(hero[heroFrame], heroX-heroOffsetX, heroY-heroOffsetY);
					heroFrameCount++;
				
				
					//labsfront
					if ((millis() - gameStartTime) > introDuration) {
						if (labsY < windowHeight) {
							image(labsfront, 376, labsfrontY);
							labsfrontY += takeoffSpeed;
							takeoffSpeed+=takeoffAcceleration;
						}
					} else {
						image(labsfront, 376, labsfrontY);
					}
				
				
					//ghost
					heroGhostX += int((heroX - heroGhostX + 25)/ghostSpeed);
					heroGhostY += int((heroY - heroGhostY + 30)/ghostSpeed);
					//rect(heroGhostX, heroGhostY, 10, 10);
					
				//end heroDestroyed	
				} else {
					displayLose();
				}
				
 
				//interface bits
				
				//show how many lives are left
				for (int i=0; i<numLives; i++) {
					image(lives, 255 + (i*30), 20);
				}
				
				//render health bar
				int barSize = 220;
				
				//render fill
				fill(#FFFFFF, 190);
				int barWidth = float(heroHealth/100) * barSize;
				rect(25, 23, barWidth, 12);
				
				//render border
				noFill();
				stroke(#FFFFFF, 100);
				rect(25, 23, barSize, 12);
				
				//render points
				
				ps = nf(points, 7);
				
				int currentXPos = windowWidth - 20;
				
				for (int i=ps.length()-1; i>0; i--) {
					
					int d = parseInt(ps.charAt(i));
					
					currentXPos -= numberWidths[d];
					image(numbers[d], currentXPos , 18);
					
				}
			//end draw	
			}
			
			
			
			void displayLose() {
 
				image(lose, (windowWidth/2) - loseOffsetX, (windowHeight/2) - loseOffsetY - 10);
 
			}
			
			void displayWin() {
				
				image(win, (windowWidth/2) - winOffsetX, (windowHeight/2) - winOffsetY - 10);
 
			}
			
			void displayTitle() {
				
				image(title, (windowWidth/2) - titleOffsetX, (windowHeight/2) - titleOffsetY);
				
				//draw frames
				int miniFrame = miniTitleFrameCount % miniNumFrames;
				//draw and position rock
				translate(154, -120);
				rotate(PI/18.0);
				image(mini[miniFrame], 340, 175);
				//increment the frameCount
				miniTitleFrameCount++;
			}
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			// ENEMIES
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			//enemy
			class Enemy {
				
				//instance vars
				int shield;
				int frameCount = 0;
				float x = 0.0;
				float y = 0.0;
				int offsetX = 0;
				int offsetY = 0;
				//sin movement
				float angle = 0.0;
				float speedx = 0.05;
				float radius = 300;
				
				//linear movement
				float startTime;
				int targetY = 0;
				
				//wave move
				int origX;
				
				//constructor
				Enemy(int xpos, int ypos, int shieldValue, int flightType) {
					x = xpos;
					y = ypos;
					shield = shieldValue;
					flight = flightType;
					startTime = millis();
					origX = x;
				}
			
				//instance
				void update() {
					//
				}
				
				void moveLinear() {
					if ((millis() - startTime) < 4000) {
						targetY = 100;
					} else {
						targetY = windowHeight + 100;
					}
					if (y < targetY) {
						y+=5;
					}
				}
				
				void moveWave() {
					radius = 300;
					y += 2.0;
					angle += speedx;
					float sinval = sin(angle);
					x = (windowWidth/2) + int(sinval * radius);
				}
				
				void moveMiniWave() {
					radius = 120;
					y += 1.5;
					angle += speedx;
					float sinval = sin(angle);
					x = origX + int(sinval * radius);
				}			
			}
			
			//spim
			class Spim extends Enemy {
				
				//instance vars
				int offsetX = int(85/2);
				int offsetY = int(77/2);
				int flight;
				int shield;
				int hits = 0;
				int pointsPerKill = 175;
				
				//constructor
				Spim(int x, int y, int shieldValue, int flightpath) {
					super(x, y, shield, flightpath);
					flight = flightpath;
					shield = shieldValue;
				}
				
				//instance methods
				void update() {
					
					//cycle through spim frames
					int spimFrame = frameCount % spimNumFrames;
					//draw and position spim
					image(spim[spimFrame], x - offsetX, y - offsetY);
					//increment the frameCount
					frameCount++;
					
					//move spim along
					switch (flight) {
						case 0:
							moveWave();
							break;
						case 1:
							moveLinear();
							break;
						case 2:
							moveMiniWave();
							break;
					}
 
				}
				
				void flash() {
					image(spim[spim.length-1], x - offsetX, y - offsetY);
				}
			}
			
			//virup
			class Virup extends Enemy {
				
				//instance vars
				int offsetX = int(89/2);
				int offsetY = int(94/2);
				int flight;
				int shield;
				int hits = 0;
				int pointsPerKill = 250;
				
				//constructor
				Virup(int x, int y, int shieldValue, int flightpath) {
					super(x, y, shieldValue, flightpath);
					flight = flightpath;
					shield = shieldValue;
				}
				//instance methods
				void update() {
					
					//cycle through virup frames
					int virupFrame = frameCount % virupNumFrames;
					//draw and position rock
					image(virup[virupFrame], x - offsetX, y - offsetY);
					//increment the frameCount
					frameCount++;
					
					//move rock along
					switch (flight) {
						case 0:
							moveWave();
							break;
						case 1:
							moveLinear();
							break;
						case 2:
							moveMiniWave();
							break;
					}
	
				}
				
				void flash() {
					image(virup[virup.length-1], x - offsetX, y - offsetY);
				}
				
			}
			
			//Rock
			class Rock extends Enemy {
				
				//instance vars
				int offsetX = int(83/2);
				int offsetY = int(79/2);
				int flight;
				int shield;
				int hits = 0;
				int pointsPerKill = 125;
				
				//constructor
				Rock(int x, int y, int shieldValue, int flightpath) {
					super(x, y, shieldValue, flightpath);
					flight = flightpath;
					shield = shieldValue;
				}
				
				//instance methods
				void update() {
					
					//cycle through virup frames
					int rockFrame = frameCount % rockNumFrames;
					//draw and position rock
					image(rock[rockFrame], x - offsetX, y - offsetY);
					//increment the frameCount
					frameCount++;
					
					//move rock along
					switch (flight) {
						case 0:
							moveWave();
							break;
						case 1:
							moveLinear();
							break;
						case 2:
							moveMiniWave();
							break;
					}
	
				}
				
				void flash() {
					image(rock[rock.length-1], x - offsetX, y - offsetY);
				}
			}
			
			
			//laser
			class Laser {
				
				int speed = 15;
				int x;
				int y;
				int offsetX = 8;
				int offsetY = 17;
				
				Laser(int xpos, int ypos) {
					x = xpos;
					y = ypos;
				}
				
				void update() {
					y -= speed;
					image(laser, x - offsetX, y);
				}
 
			}
			
			//dust
			class Dust {
				int x;
				int y;
				int offsetX = int(107/2);
				int offsetY = int(98/2);
				int currentFrame = 0;
				Dust(int xpos, int ypos) {
					x = xpos;
					y = ypos;
				}
				
				void update() {
					image(dust[currentFrame], x - offsetX, y - offsetY);
					currentFrame++;
				}
			}
			
			//boss
			class Boss {
				
				//instance vars
				int x = int(windowWidth/2);
				int y = -200;
				int targetX = 0;
				int targetY = 180;
 
				int speedY = 30;
				int offsetX = int(184/2);
				int offsetY = int(276/2);
				int frameCount = 0;
				int flight = 0;
				
				//sin movement
				float angle = 0.0;
				float speedX = 0.02;
				float radius = 200;
				int startTime = 0;
				int hits = 0;
				int shield = 5;
				boolean destroyed = false;
				int pointsPerKill = 125;
				
				//constructor
				Boss() {
					
					//create an instance of padlock
					padlockHeart = new Padlock();
					
					//create 2 new instances of arm
					leftArm = new Arm(-90, -5, "left");
					rightArm = new Arm(90, -5, "right");
					
				}
				
				//instance methods
				void update() {
	
	
	
					//cycle through virup frames
					int cageFrame = frameCount % cageNumFrames;
					//draw and position rock
					image(cage[cageFrame], x - offsetX, y - offsetY);
					//increment the frameCount
					frameCount++;
					
					//move according to fligthpath
					move();
					
					//update the padlock
					if (!padlockHeart.destroyed) {
						padlockHeart.update();
					}
					
					//update the arms
					if (!leftArm.destroyed) {
						leftArm.update();
					}
					if (!rightArm.destroyed) {
						rightArm.update();
					}
					
				}
				
				void move() {
					switch(flight) {
						case 0:
							
							//get the desire y pos
							y += int((targetY - y)/speedY);
							
							//wave pattern
							angle += speedX;
							float sinval = sin(angle);
							x = windowWidth/2 + int(sinval * radius);
							
							break;
						case 1:
							//already at the right y pos
							speedX = 10;
							//every second..
							if ((millis() - startTime) > 2000) {
								startTime = millis();
								targetX = int(random()*(windowWidth-400)) + 200;
							}
							x += int(targetX-x)/speedX;
							break;
						case 2:
							//already at the right y pos
							speedX = 10;
							//every second..
							if ((millis() - startTime) > 1000) {
								startTime = millis();
								targetX = int(random()*(windowWidth-400)) + 200;
							}
							x += int(targetX-x)/speedX;
							break;
					}
				}
				
				void flash() {
					image(cage[cage.length-1], x - offsetX, y - offsetY);
				}
			}
			
			//padlock
			class Padlock {
				
				//instance vars
				int x;
				int y;
				int offsetX = int(89/2);
				int offsetY = int(111/2);
				int hits = 0;
				int shield = 5;
				boolean destroyed = false;
				int pointsPerKill = 1500;
				
				//constructor
				Padlock() {
					//
				}
				
				//instance methods
				void update() {
					
					//keep x and y up to date
					x = inbox.x + 20;
					y = inbox.y + 90;
					
					//draw the frame
					image(padlock[0], x-offsetX, y-offsetY);
	
				}
				
				void flash() {
					image(padlock[1], x-offsetX, y-offsetY);
				}
				
			}
			
			//arms
			class Arm {
				
				//instance vars
				int x;
				int y;
				int offsetX = int(103/2);
				int offsetY = int(105/2);
				int armOffsetX = int(29/2);
				int armOffsetY = int(30/2);
				//actual position of shoulder
				int shoulderX;
				int shoulderY;
				//relative position of shoulder to inbox.0
				int shoulderXRelative;
				int shoulderYRelative;
				int restingX = 150;
				int restingY = 80;
				int armSpeed = 7;
				int attackSpeed = 20;
				int numArmParts = 20;
				int startTime;
				int attackFrequency = 5000;
				int attackOffset = int(attackFrequency/2);
				int attackDuration = 1100;
				int spacingX;
				int spacingY;
				//int targetX;
				//int targetY;
				boolean attackMode = false;
				string side;
				int frameCount = 0;
				//
				int hits = 0;
				int shield = 30;
				boolean destroyed = false;
				//
				int pointsPerKill = 1000;
				
				//constructor
				Arm(int shoulderXRelativeValue, int shoulderYRelativeValue, string sideValue) {
					
					shoulderXRelative = shoulderXRelativeValue;
					shoulderYRelative = shoulderYRelativeValue;
					side = sideValue;
 
					//
					if (side == "left") {
						startTime = millis();
					} else {
						startTime += attackOffset;
					}
			
				}
				
				//instance methods
				void update() {
				
					//for every attackFrequency we go into attackDuration
					if ((millis()-startTime) > attackFrequency) {
						
						//switch to attack
						attackMode = true;
						
						if ((millis()-startTime) > attackFrequency + attackDuration) {
							
							//reset startTime
							startTime = millis();
							if (side == "left") {
								startTime = millis();
							} else {
								startTime += attackOffset;
							}
							
							//turn attack off
							attackMode = false;
						}
					}
					
					//update actual shoulder positions
					shoulderX = inbox.x + shoulderXRelative;
					shoulderY = inbox.y + shoulderYRelative;
					
					if (!attackMode) {
	
						//update where the resting positions should be
						if (side == "left") {
							restingX = shoulderX - 60;
						} else {
							restingX = shoulderX + 60;
						}
						restingY = shoulderY + 80;
						
						//move towards the resting positions
						x += int((restingX-x)/armSpeed);
						y += int((restingY-y)/armSpeed);
						
					} else {
						//x/y is relative to heroGhostX and heroGhostY
						x += int((heroGhostX-x)/attackSpeed);
						y += int((heroGhostY-y)/attackSpeed);
					}
					
					
					spacingX = (x - shoulderX)/numArmParts;
					spacingY = (y - shoulderY)/numArmParts;
					for (int i=0; i<numArmParts; i++) {
 
						
						float angle = 0.0;
						float speed = (90/numArmParts) * (PI/180);
						float radius = (y-shoulderY);
						
						angle += (speed*i);
						float sinval = sin(angle);
						float yoffset = sinval * radius;
						image(arm[0], shoulderX + (spacingX*i) - armOffsetX, shoulderY + yoffset - armOffsetY);
						
					}
					
					
					//draw the ball at x/y
					//cycle through virup frames
					int ballFrame = frameCount % ballNumFrames;
					//draw and position rock
					image(ball[ballFrame], x - offsetX, y - offsetY);
					//increment the frameCount
					frameCount++;
					
			
				}
				
				void flash() {
					
					//
					image(ball[ball.length-1], x - offsetX, y - offsetY);
					
				}
				
			}
			
			//minis
			class MiniG {
				
				int x;
				int y;
				int offsetX = int(90/2);
				int offsetY = int(36/2);
				int frameCount;
				
				//moving in circular motion
				float angle = 0.0;
				float angleSpeed;
				int speed;
				float radius;
				
				MiniG(int startX, int startY, float radiusValue, int speedValue, float angleSpeedValue) {
					
					x = startX;
					y = startY;
					radius = radiusValue;
					speed = speedValue;
					angleSpeed = angleSpeedValue;
					
				}
				
				void update() {
					
					/*
					x += ((heroX + heroOffsetX - x)/speed);
					y += ((heroY + heroOffsetY - y)/speed);
					*/
					
					//float radius = 100;
					angle += angleSpeed;
					float sinval = sin(angle);
					float cosval = cos(angle);
 
 
					x += (((heroX) + int(sinval * (radius)))-x)/speed;
					y += (((heroY) + int(cosval * (radius)))-y)/speed;
					
					//draw frames
					int miniFrame = frameCount % miniNumFrames;
					//draw and position rock
					image(mini[miniFrame], x - offsetX, y - offsetY);
					//increment the frameCount
					frameCount++;
					
					
				}
				
			}
			
			//restart game
			void restartGame() {
				
				
				currentEnemies = new ArrayList();
				currentMini = new ArrayList();
				currentDust = new ArrayList();
				currentLasers = new ArrayList();
				
				//unpaused if paused
				paused = false;
				loop();
				
				//reposition hero
				targetX = int(windowWidth/2);
				targetY = 450;
				heroX = targetX;
				heroY = 450;
				
				//
				bossCreated = false;
				
				//give hero back its health
				numLives = 5;
				heroHealth = 100;
	
				//undo heroDestroyed
				heroDestroyed = false;
				
				//restart the gameStartTime
				gameStartTime = millis();
				
				//reset the enemyArrPointer
				enemyArrPointer = 0;
				
				//
				dustCounter = 0;
				
				//
				gameStarted = false;
				
				//
				labsY = windowHeight - 292;
				labsfrontY = 383;
				takeoffSpeed = 0.0;
				
				keysLocked = true;
				
				points = 0;
				
				
			}
			
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			// INPUT CONTROLS
			///////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			void keyPressed() {
				
				if (key == 13 && (heroDestroyed || inbox.destroyed)) {
					restartGame();
				}
				
				//shoot lasers
				if (key == 32 && gameFocused) {
					if (gameStarted) {
						if ((millis() - gameStartTime) > introDuration) {
							if ((millis() - lastLaserFired) > 150) {
								l = new Laser(heroX, heroY - 50);
								currentLasers.add(l);
								lastLaserFired = millis();
							}
							
							if (paused) {
								loop();
								paused = false;
								gameStartTime += (millis() - timePaused);
							}
						}
					} else {
						gameStartTime = millis();
						gameStarted = true;
					}
				}
				
				//move around
				
				if (!keysLocked && keyCode == UP && ((targetY-speedY) > (0-heroOffsetY))) {
					targetY -= speedY;
				} else if (!keysLocked && keyCode == DOWN && ((targetY+speedY) < windowHeight)) {
					targetY += speedY;
				} else if (!keysLocked && keyCode == LEFT && ((targetX-speedX) > 0)) {
					targetX -= speedX;
				} else if (!keysLocked && keyCode == RIGHT && ((targetX-speedX) < windowWidth - (heroOffsetX*3))) {
					targetX += speedX;
				}
				
				//restart 'r' pressed
				if (key == 114) {
					restartGame();
				}
				
				
				//pause 'p' pressed
				if (key == 112) {
					if (paused) {
						loop();
						paused = false;
						gameStartTime += (millis() - timePaused);
					} else {
						noLoop();
						paused = true;
						//capture the time now - when we unpause we need to add the difference between this value and millis to the original timeStart
						timePaused = millis();
					}
					
				}
				/*
				if (key == 109) {
					mouseEnabled = true;
					noCursor();
				}*/
				
			}
 
			/*
			void mousePressed() {
				l = new Laser(heroX + heroOffsetX, heroY-17);
				currentLasers.add(l);
			}
			*/
			
			void mousePressed() {
				if (assetsPreloaded && !gameFocused) {
					gameFocused = true;
				}
			}
