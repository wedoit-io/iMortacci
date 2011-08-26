//
//  iMortacci.h
//  iMortacci
//
//  Created by Ali Servet Donmez on 25.3.11.
//  Copyright 2011 Apex-net srl. All rights reserved.
//

#import "UIColor-Expanded.h"

// App settings
#define kAppName            @"iMortacci"
#define kAppVersion         @"1.0"

// Various urls
#define kSiteURL            @"http://www.imortacci.com"
#define kPlayerURL          @"http://www.imortacci.com/it/player"
#define kThumbnailURL       @"http://www.imortacci.com/public/imortacci/regioni"
#define kICanDoBetterURL    @"http://www.imortacci.com/it/p/sai-fare-meglio"
#define kInfoURL            @"mailto:info@imortacci.com"
#define k2mlabURL           @"http://www.2mlab.com"
#define kApexNetURL         @"http://www.apexnet.it"

// iMortacci API and reachability
#define kAPIURL                 @"http://imortacci.apexnet.it/api/v1"
#define kReachabilityHostName   @"google.com"

// Push notifications api
#define kAppServerUrl           @"http://notificatore.apexnet.it/Notificatore.aspx"

#if DEBUG
    #define kAppKey         @"IMORTACCI_DEV"
#else
    #define kAppKey         @"IMORTACCI"
#endif

// Sharing settings
#define kFacebookAppID          @"138911126174224"
#define kTwitterConsumerKey		@"Nq00YeOiOIXeJLwuBiTXrg"
#define kTwitterSecret			@"pbdrFjFyTyfPkQoTWPVsFfcW2IKu5u6HfQSXmPEA"
#define kTwitterCallbackUrl		@"http://callback.imortacci.com"
#define kBitLyLogin				@"imortacci"
#define kBitLyKey				@"R_0653d7e5f6f3a7be96a6014b6e958685"

#define kSoundCloudClientId     @"7Eo3B0odlpK5FvOVUKDnQ"
#define kAdWhirlApplicationKey  @"9036ba7fc12341f0bdadc4c569707817"

// Google Analytics
#define kGANWebPropertyID       @"UA-20354938-3"
// Dispatch period in seconds
#define kGANDispatchPeriodSec   10

// App filenames for convenience
#define kCurrentVersionFileName     @"version.json"
#define kAlbumsFileName             @"albums.json"
#define kUserInfoFileName           @"userinfo.json"
#define kCountersFileName           @"counters.json"
#define kFavoritesFileName          @"favorites.json"

// Useful contants
#define kTrackFileExtension             @"mp3"
#define kAlbumArtworkFileExtension      @"png"

// UI color definitions
#define kIMORColorWhite     [UIColor colorWithHexString:@"ecebdc"]
#define kIMORColorYellow    [UIColor colorWithHexString:@"fbbd10"]
#define kIMORColorOrange    [UIColor colorWithHexString:@"e35b1b"]
#define kIMORColorGreen     [UIColor colorWithHexString:@"3ea5a2"]
#define kIMORColorBrown     [UIColor colorWithHexString:@"333333"]
#define kIMORColorGray      [UIColor colorWithHexString:@"555555"]
#define kIMORColorShadow    [UIColor colorWithHexString:@"256B69"]

// Useful values
#define kSearchTableRowHeight           60.0
#define kSingleRowTableRowHeight        317.0
