//
//  ServiceConfig.h
//  pet2share
//
//  Created by Tony Kieu on 8/2/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#ifndef pet2share_ServiceConfig_h
#define pet2share_ServiceConfig_h

///------------------------------------------------------------------------------
///
/// Turn on the flag LOCALWEBSERVICE_TEST and specify local web service url to
/// requests locally or on a speficic host.
///
///------------------------------------------------------------------------------

#define LOCALWEBSERVICE_TEST 1         // Turn on local testing mode

#define PET2SHARE_DEV_LOCAL_URL             @"http://localhost:8080"
#define PET2SHARE_DEV_URL                   @""
#define PET2SHARE_QA_URL                    @""
#define PET2SHARE_STAGING_URL               @""
#define PET2SHARE_PROD_URL                  @""

#define PET2SHARE_DEV_LOCAL_WEBSERVICE_PATH @"/api"
#define PET2SHARE_DEV_WEBSERVICE_PATH       @""
#define PET2SHARE_QA_WEBSERVICE_PATH        @""
#define PET2SHARE_STAGING_WEBSERVICE_PATH   @""
#define PET2SHARE_PROD_WEBSERVICE_PATH      @""

#define PET2SHARE_DEV_KEY                   @"dev"
#define PET2SHARE_QA_KEY                    @"qa"
#define PET2SHARE_STAGING_KEY               @"staging"
#define PET2SHARE_PROD_KEY                  @"production"

///------------------------------------------------------------------------------
/// ENDPOINTS
///------------------------------------------------------------------------------

#define AUTHENTICATE_ENDPOINT               @"/authenticate/%@/%@"

#endif
