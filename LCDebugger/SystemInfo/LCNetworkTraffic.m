//
//
//      _|          _|_|_|
//      _|        _|
//      _|        _|
//      _|        _|
//      _|_|_|_|    _|_|_|
//
//
//  Copyright (c) 2014-2015, Licheng Guo. ( http://nsobject.me )
//  http://github.com/titman
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "LCNetworkTraffic.h"

#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>


#define APP_TRAFFIC_WIFISENT @"appTrafficWiFiSent"
#define APP_TRAFFIC_WIFIRECEIVED @"appTrafficWiFiReceived"
#define APP_TRAFFIC_WWANSENT @"appTrafficWWANSent"
#define APP_TRAFFIC_WWANRECEIVED @"appTrafficWWANReceived"
#define APP_TRAFFIC_ERRORCNT @"appTrafficErrorCnt"


@interface LCNetworkTraffic () {
  struct LCNetworkTrafficValues appCounters;
  struct LCNetworkTrafficValues appChanges;
}

@property(assign, nonatomic) struct LCNetworkTrafficValues  *changes;
@property(assign, nonatomic) struct LCNetworkTrafficValues  *counters;
@property(assign, nonatomic) struct LCNetworkTrafficValues  networkTrafficPrevValues;

@end


@implementation LCNetworkTraffic

#pragma mark - Properties

#pragma mark -Public

- (struct LCNetworkTrafficValues *)changes {
  [self calcChanges];
  
  return _changes;
}

- (struct LCNetworkTrafficValues *)counters {
  [self fillCountersByUserDefaultsValues];
  
  return _counters;
}


#pragma mark - Public methods

#pragma mark -Nonstatic

- (void)resetChanges
{
  memset(&appChanges, 0, sizeof appChanges);
  
  struct LCNetworkTrafficValues trafficCounters = {0};
  [[self class] getTrafficCounters:&trafficCounters];
  self.networkTrafficPrevValues = trafficCounters;
}


#pragma mark - Private methods

#pragma mark -Static

+ (void)getTrafficCounters:(struct LCNetworkTrafficValues *)networkTrafficCounters
{
  BOOL   success;
  struct ifaddrs *addrs;
  const struct ifaddrs *cursor;
  const struct if_data *networkStatisc;
  
  // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
  NSString *interfaceName = nil;
  
  success = getifaddrs(&addrs) == 0;
  if (success)
  {
    cursor = addrs;
    while (cursor != NULL)
    {
      interfaceName = [NSString stringWithFormat:@"%s", cursor->ifa_name];
      //            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name, interfaceName);
      
      if (cursor->ifa_addr->sa_family == AF_LINK) {
        // WiFi
        if ([interfaceName hasPrefix:@"en"]) {
          networkStatisc = (const struct if_data *) cursor->ifa_data;
          networkTrafficCounters->WiFiSent += networkStatisc->ifi_obytes;
          networkTrafficCounters->WiFiReceived += networkStatisc->ifi_ibytes;
          networkTrafficCounters->errorCnt += networkStatisc->ifi_ierrors + networkStatisc->ifi_oerrors;
        }
        
        // WWAN
        if ([interfaceName hasPrefix:@"pdp_ip"]) {
          networkStatisc = (const struct if_data *)cursor->ifa_data;
          networkTrafficCounters->WWANSent += networkStatisc->ifi_obytes;
          networkTrafficCounters->WWANReceived += networkStatisc->ifi_ibytes;
          networkTrafficCounters->errorCnt += networkStatisc->ifi_ierrors + networkStatisc->ifi_oerrors;
        }
      }
      
      cursor = cursor->ifa_next;
    }
    
    freeifaddrs(addrs);
  }
}

#pragma mark -Nonstatic

- (void)calcChanges {
  if (!_changes) {
    _changes = &appChanges;
  }

  struct LCNetworkTrafficValues trafficCounters = {0};
  [[self class] getTrafficCounters:&trafficCounters];
  
  _changes->WiFiReceived  += trafficCounters.WiFiReceived - self.networkTrafficPrevValues.WiFiReceived;
  _changes->WiFiSent      += trafficCounters.WiFiSent - self.networkTrafficPrevValues.WiFiSent;
  _changes->WWANReceived  += trafficCounters.WWANReceived - self.networkTrafficPrevValues.WWANReceived;
  _changes->WWANSent      += trafficCounters.WWANSent - self.networkTrafficPrevValues.WWANSent;
  _changes->errorCnt      += trafficCounters.errorCnt - self.networkTrafficPrevValues.errorCnt;
  
  [self fillCountersByUserDefaultsValues];
    
  _counters->errorCnt     += trafficCounters.errorCnt - self.networkTrafficPrevValues.errorCnt;
  _counters->WiFiSent     += trafficCounters.WiFiSent - self.networkTrafficPrevValues.WiFiSent;
  _counters->WiFiReceived += trafficCounters.WiFiReceived - self.networkTrafficPrevValues.WiFiReceived;
  _counters->WWANSent     += trafficCounters.WWANSent - self.networkTrafficPrevValues.WWANSent;
  _counters->WWANReceived += trafficCounters.WWANReceived - self.networkTrafficPrevValues.WWANReceived;
//  [[NSUserDefaults standardUserDefaults] setInteger:_counters->errorCnt forKey:APP_TRAFFIC_ERRORCNT];
//  [[NSUserDefaults standardUserDefaults] setInteger:_counters->WiFiSent forKey:APP_TRAFFIC_WIFISENT];
//  [[NSUserDefaults standardUserDefaults] setInteger:_counters->WiFiReceived forKey:APP_TRAFFIC_WIFIRECEIVED];
//  [[NSUserDefaults standardUserDefaults] setInteger:_counters->WWANSent forKey:APP_TRAFFIC_WWANSENT];
//  [[NSUserDefaults standardUserDefaults] setInteger:_counters->WWANReceived forKey:APP_TRAFFIC_WWANRECEIVED];
//  [[NSUserDefaults standardUserDefaults] synchronize];
  
  self.networkTrafficPrevValues = trafficCounters;
}

- (void)fillCountersByUserDefaultsValues {
  if (!_counters) {
    _counters = &appCounters;
  }

//  _counters->errorCnt = [[NSUserDefaults standardUserDefaults] integerForKey:APP_TRAFFIC_ERRORCNT];
//  _counters->WiFiSent = [[NSUserDefaults standardUserDefaults] integerForKey:APP_TRAFFIC_WIFISENT];
//  _counters->WiFiReceived = [[NSUserDefaults standardUserDefaults] integerForKey:APP_TRAFFIC_WIFIRECEIVED];
//  _counters->WWANSent = [[NSUserDefaults standardUserDefaults] integerForKey:APP_TRAFFIC_WWANSENT];
//  _counters->WWANReceived = [[NSUserDefaults standardUserDefaults] integerForKey:APP_TRAFFIC_WWANRECEIVED];
}

-(NSString *) allTraffic
{
    struct LCNetworkTrafficValues temp = *[self changes];

    float kb = (temp.WiFiSent + temp.WiFiReceived + temp.WWANSent + temp.WWANReceived) / 1024 / 1024;
    
    if (kb < 1024 * 1024) {
        
        return [NSString stringWithFormat:@"%.0fKB",kb];
    }
    
    if (kb < 1024 * 1024 * 1024) {
        
        return [NSString stringWithFormat:@"%.0fMB",kb / 1024];
    }
    
    else{
        
        return [NSString stringWithFormat:@"%.1fGB",kb / 1024 / 1024 ];
    }
    
    return @"0";
}

@end
