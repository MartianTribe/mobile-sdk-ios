/*   Copyright 2017 APPNEXUS INC
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <XCTest/XCTest.h>
#import "ANUniversalTagRequestBuilder.h"
#import "ANSDKSettings+PrivateMethods.h"
#import "ANUniversalAdFetcher.h"
#import "ANGlobal.h"
#import "ANTestGlobal.h"
#import "ANReachability.h"
#import "TestANUniversalFetcher.h"
#import "ANGDPRSettings.h"


static NSString *const   kTestUUID              = @"0000-000-000-00";
static NSTimeInterval    UTMODULETESTS_TIMEOUT  = 20.0;

static NSString  *videoPlacementID  = @"9924001";



@interface ANUniversalTagRequestBuilderFunctionalTests : XCTestCase
    //EMPTY
@end



@implementation ANUniversalTagRequestBuilderFunctionalTests

#pragma mark - Test lifecycle.

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    [super tearDown];
}

- (void)testUTRequestForSetGDPRConsentTrue
{
    [ANGDPRSettings setConsentRequired:true];
    [ANGDPRSettings setConsentString:@"a390129402948384453"];
    
    NSString                *urlString      = [[[ANSDKSettings sharedInstance] baseUrlConfig] utAdRequestBaseUrl];
    TestANUniversalFetcher  *adFetcher      = [[TestANUniversalFetcher alloc] initWithPlacementId:videoPlacementID];
    NSURLRequest            *request        = [ANUniversalTagRequestBuilder buildRequestWithAdFetcherDelegate:adFetcher.delegate baseUrlString:urlString];
    XCTestExpectation       *expectation    = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                       NSError *error;
                       
                       id jsonObject = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                                       options:kNilOptions
                                                                         error:&error];
                       TESTTRACEM(@"jsonObject=%@", jsonObject);
                       
                       XCTAssertNil(error);
                       XCTAssertNotNil(jsonObject);
                       XCTAssertTrue([jsonObject isKindOfClass:[NSDictionary class]]);
                       NSDictionary *jsonDict = (NSDictionary *)jsonObject;
                       
                       NSDictionary *gdpr_consent = jsonDict[@"gdpr_consent"];
                       XCTAssertNotNil(gdpr_consent);
                       XCTAssertEqual(gdpr_consent.count, 2);
                       XCTAssertNotNil(gdpr_consent[@"consent_required"]);
                       XCTAssertTrue([gdpr_consent[@"consent_required"] boolValue]);
                       XCTAssertNotNil(gdpr_consent[@"consent_string"]);
                       [expectation fulfill];
                   });
    
    [self waitForExpectationsWithTimeout:UTMODULETESTS_TIMEOUT handler:nil];
}

- (void)testUTRequestForSetGDPRConsentFalse
{
    [ANGDPRSettings setConsentRequired:false];
    [ANGDPRSettings setConsentString:@"a390129402948384453"];
    
    NSString                *urlString      = [[[ANSDKSettings sharedInstance] baseUrlConfig] utAdRequestBaseUrl];
    TestANUniversalFetcher  *adFetcher      = [[TestANUniversalFetcher alloc] initWithPlacementId:videoPlacementID];
    NSURLRequest            *request        = [ANUniversalTagRequestBuilder buildRequestWithAdFetcherDelegate:adFetcher.delegate baseUrlString:urlString];
    XCTestExpectation       *expectation    = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                       NSError *error;
                       
                       id jsonObject = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                                       options:kNilOptions
                                                                         error:&error];
                       TESTTRACEM(@"jsonObject=%@", jsonObject);
                       
                       XCTAssertNil(error);
                       XCTAssertNotNil(jsonObject);
                       XCTAssertTrue([jsonObject isKindOfClass:[NSDictionary class]]);
                       NSDictionary *jsonDict = (NSDictionary *)jsonObject;
                       
                       NSDictionary *gdpr_consent = jsonDict[@"gdpr_consent"];
                       XCTAssertNotNil(gdpr_consent);
                       XCTAssertEqual(gdpr_consent.count, 2);
                       XCTAssertNotNil(gdpr_consent[@"consent_required"]);
                       XCTAssertFalse([gdpr_consent[@"consent_required"] boolValue]);
                       XCTAssertNotNil(gdpr_consent[@"consent_string"]);
                       [expectation fulfill];
                   });
    
    [self waitForExpectationsWithTimeout:UTMODULETESTS_TIMEOUT handler:nil];
}


- (void)testUTRequestForSetGDPRDefaultConsent
{


    [ANGDPRSettings reset];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IABConsent_ConsentString"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IABConsent_SubjectToGDPR"];
    
    NSString                *urlString      = [[[ANSDKSettings sharedInstance] baseUrlConfig] utAdRequestBaseUrl];
    TestANUniversalFetcher  *adFetcher      = [[TestANUniversalFetcher alloc] initWithPlacementId:videoPlacementID];
    NSURLRequest            *request        = [ANUniversalTagRequestBuilder buildRequestWithAdFetcherDelegate:adFetcher.delegate baseUrlString:urlString];
    XCTestExpectation       *expectation    = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                       NSError *error;
                       
                       id jsonObject = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                                       options:kNilOptions
                                                                         error:&error];
                       TESTTRACEM(@"jsonObject=%@", jsonObject);
                       
                       XCTAssertNil(error);
                       XCTAssertNotNil(jsonObject);
                       XCTAssertTrue([jsonObject isKindOfClass:[NSDictionary class]]);
                       NSDictionary *jsonDict = (NSDictionary *)jsonObject;
                       XCTAssertNil(jsonDict[@"gdpr_consent"]);
                       [expectation fulfill];
                   });
    
    [self waitForExpectationsWithTimeout:UTMODULETESTS_TIMEOUT handler:nil];
}

- (void)testUTRequestCheckConsentForGDPRIABConsentStringWithTrue
{
    [ANGDPRSettings reset];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"IABConsent_SubjectToGDPR"];
    [[NSUserDefaults standardUserDefaults] setObject:@"a390129402948384453" forKey:@"IABConsent_ConsentString"];
  
    NSString                *urlString      = [[[ANSDKSettings sharedInstance] baseUrlConfig] utAdRequestBaseUrl];
    TestANUniversalFetcher  *adFetcher      = [[TestANUniversalFetcher alloc] initWithPlacementId:videoPlacementID];
    NSURLRequest            *request        = [ANUniversalTagRequestBuilder buildRequestWithAdFetcherDelegate:adFetcher.delegate baseUrlString:urlString];
    XCTestExpectation       *expectation    = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                       NSError *error;
                       
                       id jsonObject = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                                       options:kNilOptions
                                                                         error:&error];
                       TESTTRACEM(@"jsonObject=%@", jsonObject);
                       
                       XCTAssertNil(error);
                       XCTAssertNotNil(jsonObject);
                       XCTAssertTrue([jsonObject isKindOfClass:[NSDictionary class]]);
                       NSDictionary *jsonDict = (NSDictionary *)jsonObject;
                      
                       NSDictionary *gdpr_consent = jsonDict[@"gdpr_consent"];
                       XCTAssertNotNil(gdpr_consent);
                       XCTAssertEqual(gdpr_consent.count, 2);
                       XCTAssertNotNil(gdpr_consent[@"consent_required"]);
                       XCTAssertTrue([gdpr_consent[@"consent_required"] boolValue]);
                       XCTAssertNotNil(gdpr_consent[@"consent_string"]);
                       [expectation fulfill];
                   });
    
    [self waitForExpectationsWithTimeout:UTMODULETESTS_TIMEOUT handler:nil];
}


- (void)testUTRequestCheckConsentForIABConsentStringWithFalse
{
     [ANGDPRSettings  reset];
    [[NSUserDefaults standardUserDefaults] setObject:@"a390129402948384453" forKey:@"IABConsent_ConsentString"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"IABConsent_SubjectToGDPR"];
    
    NSString                *urlString      = [[[ANSDKSettings sharedInstance] baseUrlConfig] utAdRequestBaseUrl];
    TestANUniversalFetcher  *adFetcher      = [[TestANUniversalFetcher alloc] initWithPlacementId:videoPlacementID];
    NSURLRequest            *request        = [ANUniversalTagRequestBuilder buildRequestWithAdFetcherDelegate:adFetcher.delegate baseUrlString:urlString];
    XCTestExpectation       *expectation    = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                       NSError *error;
                       
                       id jsonObject = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                                       options:kNilOptions
                                                                         error:&error];
                       TESTTRACEM(@"jsonObject=%@", jsonObject);
                       
                       XCTAssertNil(error);
                       XCTAssertNotNil(jsonObject);
                       XCTAssertTrue([jsonObject isKindOfClass:[NSDictionary class]]);
                       NSDictionary *jsonDict = (NSDictionary *)jsonObject;
                       
                       NSDictionary *gdpr_consent = jsonDict[@"gdpr_consent"];
                       XCTAssertNotNil(gdpr_consent);
                       XCTAssertEqual(gdpr_consent.count, 2);
                       XCTAssertNotNil(gdpr_consent[@"consent_required"]);
                       XCTAssertFalse([gdpr_consent[@"consent_required"] boolValue]);
                       XCTAssertNotNil(gdpr_consent[@"consent_string"]);
                       [expectation fulfill];
                   });
    
    [self waitForExpectationsWithTimeout:UTMODULETESTS_TIMEOUT handler:nil];
}


@end
