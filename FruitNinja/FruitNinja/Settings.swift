//
//  Settings.swift
//  Zombie Slayer
//
//  Created by Josh Crane on 5/22/15
//

import Foundation

//Set the scale of the blade! If you change the scale then it is RECOMMENDED to change the radius also!!!
let BladeScale:Float = 0.6
let BladePhysicalBodyRadius:Float = 16

//FRUIT FREQUENCY -> How many foods to fire on each level -> Level changes depending on your score !
let FruitsToFireInLevel2:Int = 3
let FruitsToFireInLevel3:Int = 5
let FruitsToFireInLevel4:Int = 7
let FruitsToFireInLevel5:Int = 8

//If score is bigger then it will move to a next level
let scoreToPassLevel1:Int = 4
let scoreToPassLevel2:Int = 10
let scoreToPassLevel3:Int = 30
let scoreToPassLevel4:Int = 100


//****** ADS ******\\
//*******************

//Adjust which ads do you want to show note you can have only 1 banner active
//Interstitials
let showRevMob:Bool = true
let showChartboost:Bool = false

//Banners
let showiAD:Bool = false
let showAdMob:Bool = true

//Google banner app unit id
let kGoogleBannerAppUnitID = "ca-app-pub-2173357706072839/7633740306";

//Revmob id
let kRevmobID = "555e4d991db5976f253c6f82";

//Chartboost app id and signature
let kChartboostAppID = "555e4e110d60254ff3fc146d";
let kChartboostAppSignature = "ef0bf033106af9f218263786e8c594a28d124df0";

//************ GAME SETTINGS ***************//
//******************************************//

//In-App Purchase ID
let InAppIDString:NSString = "com.test.300"

//Game Center Leaderboard ID
let GameCenterLeaderboardID:NSString = "com.test.classic"

//Sharing message and link and image name
let ShareMessage:NSString = "Hey, check out this awesome app"
let ShareItunesLink:NSString = "https://itunes.apple.com/us/app/booklet-by-velosys/id922535557?mt=8"
let ShareImageName:NSString = "Background2.png"

//Adjust the player lifes
let playerLifes:Int = 5

//************ GAME GRAPHICS ***************//
//******************************************//

//Game FONT -> The current font is a custom font if you want to add custom font then go to the project->Build Phases->Copy Files-> click the + and add the font there then just write the FULL name (TO SEE THE FULL NAME RIGHT CLICK ON THE FONT AND CLICK GET INFO INSIDE THERE SHOULD BE FIELD CALLED NAME)
let GameFontName:NSString = "Gang of Three"

let waterMelonFullImage:NSString = "zombie1.png"
let waterMelonLeftPartImage:NSString = "leftHalf.png"
let waterMelonRightPartImage:NSString = "rightHalf.png"

let kiwiFullImage:NSString = "zombie2.png"
let kiwiLeftPartImage:NSString = "kiwiLeft.png"
let kiwiRightPartImage:NSString = "kiwiRight.png"

let lemonFullImage:NSString = "zombie3.png"
let lemonLeftPartImage:NSString = "lemonLeft.png"
let lemonRightPartImage:NSString = "lemonRight.png"

let pineAppleFullImage:NSString = "zombie4.png"
let pineAppleLeftPartImage:NSString = "pineappleLeft.png"
let pineAppleRightPartImage:NSString = "pineappleRight.png"

let strawberryFullImage:NSString = "zombie6.png"
let strawberryLeftPartImage:NSString = "strawberryLeft.png"
let strawberryRightPartImage:NSString = "strawberryRight.png"

let bombFullImage:NSString = "Bomb.png"

