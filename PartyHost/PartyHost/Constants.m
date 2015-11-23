//
//  Constants.m
//  PartyHost
//
//  Created by Tony Suriyathep on 6/19/15.
//  Copyright (c) 2015 Sunny Clark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

NSString *const PHVersion = @"1.0.1";
BOOL const PHMixPanelOn = YES;

//DEBUG, should be NO when released!
BOOL const PHDebugOn = NO;

//URLs with substitution
NSString *const PHBaseURL = @"https://jiggie.herokuapp.com/app/v3";
NSString *const PHBaseDomain = @"https://jiggie.herokuapp.com";

//NSString *const PHBaseDomain = @"https://partyhostapp.herokuapp.com";
//NSString *const PHBaseURL = @"https://partyhostapp.herokuapp.com/app/v3";




NSString *const PHEventsURL = @"/events/:account_type/upcoming/:fb_id";
NSString *const PHGuestListingsURL = @"/guestlistings/:event_id/:fb_id";
NSString *const PHHostListingsURL = @"/hostlistings/:event_id/:fb_id";
NSString *const PHEventImageURL = @"/images/event/:event_id";
NSString *const PHFBProfileImageURL = @"/profile_image_url?fb_id=:fb_id";
NSString *const PHGuestEventsViewedURL = @"/guest/events/viewed/:fb_id/:event_id";
NSString *const PHEventProductsURL = @"/productlist/:event_id";
NSString *const PHTicketAddURL = @"/tickets/add/:fb_id/:event_id";
NSString *const PHUserTagListURL = @"/user/tagslist";
NSString *const PHOrdersAllURL = @"/user/orders/all/:fb_id";
NSString *const PHPhoneVerifySendURL = @"/user/phone/verification/send/:fb_id/:phone";
NSString *const PHPhoneVerifyValidateURL = @"/user/phone/verification/validate/:fb_id/:token";
NSString *const PHHostingsAddURL = @"/hostings/add/:fb_id/:event_id"; //Input (description,offerings)
NSString *const PHUserPaymentURL = @"/user/payment/:fb_id"; //Can be GET or POST (card_name,card_number,cvv,card_date (format mm/yyyy)
NSString *const PHMemberSettingsURL = @"/membersettings";
NSString *const PHMemberInfoURL = @"/memberinfo/:account_type/:member_fb_id/:fb_id";
NSString *const PHMemberMutualFriendsURL = @"/fbmutualfriends/:fb_id/:member_fb_id";
NSString *const PHBlankImgURL = @"https://partyhostapp.herokuapp.com/img/fbperson_blank_square.png";

//Date formats
NSString *const PHDateFormatShort = @"MMM d, yyyy h:mm a"; //This is the format for date_str from API
NSString *const PHDateFormatServer = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ"; //Native server usually sends this


int const PHTabHeight = 50; //Tabs at bottom of screen
int const PHButtonHeight = 50; //This is the button at bottom of screen




@implementation Constants : NSObject

+(NSString*)userPaymentURL:(NSString*)fb_id
{
    NSString *url = [NSString stringWithString:PHUserPaymentURL];
    url = [url stringByReplacingOccurrencesOfString:@":fb_id" withString:fb_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)hostingsAddURL:(NSString*)fb_id event_id:(NSString*)event_id
{
    NSString *url = [NSString stringWithString:PHHostingsAddURL];
    url = [url stringByReplacingOccurrencesOfString:@":fb_id" withString:fb_id];
    url = [url stringByReplacingOccurrencesOfString:@":event_id" withString:event_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)memberInfoURL:(NSString*)account_type member_fb_id:(NSString*)member_fb_id fb_id:(NSString*)fb_id
{
    NSString *url = [NSString stringWithString:PHMemberInfoURL];
    url = [url stringByReplacingOccurrencesOfString:@":fb_id" withString:fb_id];
    url = [url stringByReplacingOccurrencesOfString:@":member_fb_id" withString:member_fb_id];
    url = [url stringByReplacingOccurrencesOfString:@":account_type" withString:account_type];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)memberMutualFriendsURL:(NSString*)fb_id member_fb_id:(NSString*)member_fb_id
{
    NSString *url = [NSString stringWithString:PHMemberMutualFriendsURL];
    url = [url stringByReplacingOccurrencesOfString:@":fb_id" withString:fb_id];
    url = [url stringByReplacingOccurrencesOfString:@":member_fb_id" withString:member_fb_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)memberSettingsURL
{
    NSString *url = [NSString stringWithString:PHMemberSettingsURL];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)userTagListURL
{
    NSString *url = [NSString stringWithString:PHUserTagListURL];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)ordersAllURL:(NSString*)fb_id
{
    NSString *url = [NSString stringWithString:PHOrdersAllURL];
    url = [url stringByReplacingOccurrencesOfString:@":fb_id" withString:fb_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)eventsURL:(NSString*)account_type fb_id:(NSString*)fb_id
{
    NSString *url = [NSString stringWithString:PHEventsURL];
    url = [url stringByReplacingOccurrencesOfString:@":account_type" withString:account_type];
    url = [url stringByReplacingOccurrencesOfString:@":fb_id" withString:fb_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)phoneVerifySendURL:(NSString*)fb_id phone:(NSString*)phone
{
    NSString *url = [NSString stringWithString:PHPhoneVerifySendURL];
    url = [url stringByReplacingOccurrencesOfString:@":phone" withString:phone];
    url = [url stringByReplacingOccurrencesOfString:@":fb_id" withString:fb_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)phoneVerifyValidateURL:(NSString*)fb_id token:(NSString*)token
{
    NSString *url = [NSString stringWithString:PHPhoneVerifyValidateURL];
    url = [url stringByReplacingOccurrencesOfString:@":token" withString:token];
    url = [url stringByReplacingOccurrencesOfString:@":fb_id" withString:fb_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)guestListingsURL:(NSString*)event_id fb_id:(NSString*)fb_id
{
    NSString *url = [NSString stringWithString:PHGuestListingsURL];
    url = [url stringByReplacingOccurrencesOfString:@":event_id" withString:event_id];
    url = [url stringByReplacingOccurrencesOfString:@":fb_id" withString:fb_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)guestEventsViewedURL:(NSString*)event_id fb_id:(NSString*)fb_id
{
    NSString *url = [NSString stringWithString:PHGuestEventsViewedURL];
    url = [url stringByReplacingOccurrencesOfString:@":event_id" withString:event_id];
    url = [url stringByReplacingOccurrencesOfString:@":fb_id" withString:fb_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)hostListingsURL:(NSString*)event_id fb_id:(NSString*)fb_id
{
    NSString *url = [NSString stringWithString:PHHostListingsURL];
    url = [url stringByReplacingOccurrencesOfString:@":event_id" withString:event_id];
    url = [url stringByReplacingOccurrencesOfString:@":fb_id" withString:fb_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)eventImageURL:(NSString*)event_id
{
    NSString *url = [NSString stringWithString:PHEventImageURL];
    url = [url stringByReplacingOccurrencesOfString:@":event_id" withString:event_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseDomain,url];
}

+(NSString*)eventProductsURL:(NSString*)event_id
{
    NSString *url = [NSString stringWithString:PHEventProductsURL];
    url = [url stringByReplacingOccurrencesOfString:@":event_id" withString:event_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)ticketAddURL:(NSString*)fb_id event_id:(NSString*)event_id
{
    NSString *url = [NSString stringWithString:PHTicketAddURL];
    url = [url stringByReplacingOccurrencesOfString:@":event_id" withString:event_id];
    url = [url stringByReplacingOccurrencesOfString:@":fb_id" withString:fb_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseURL,url];
}

+(NSString*)fbProfileImageURL:(NSString*)fb_id
{
    NSString *url = [NSString stringWithString:PHFBProfileImageURL];
    url = [url stringByReplacingOccurrencesOfString:@":fb_id" withString:fb_id];
    return [NSString stringWithFormat:@"%@%@",PHBaseDomain,url];
}

//Convert dates from the server to a nicer display string
+(NSString*)toDisplayDate:(NSString*)dbStartDateString
{
    /*
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [format setDateFormat:PHDateFormatShort];
    NSDate *startDate = [format dateFromString:dbStartDateString];
    [format setDateFormat:@"EEE MMM d"];
    NSString *datePart1 = [format stringFromDate:startDate];
    [format setDateFormat:@"h:mma"];
    NSString *datePart2 = [[format stringFromDate:startDate] lowercaseString];
    return [NSString stringWithFormat:@"%@ %@",datePart1,datePart2];
    */
    
    //Jun 22, 2015 5:00 PM
    NSArray *dateParts = [dbStartDateString componentsSeparatedByString:@" "];
    NSString *result = [NSString stringWithFormat:@"%@ %@ %@%@",dateParts[0],dateParts[1],dateParts[3],[dateParts[4] lowercaseString]];
    
    //NSLog(@">>> %@ %@ ",dbStartDateString,result);
    
    return result;
}

//Convert dates from the server to a nicer display string range
+(NSString*)toDisplayDateRange:(NSString*)dbStartDateString dbEndDateString:(NSString*)dbEndDateString
{
    /*
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [format setDateFormat:PHDateFormatShort];
    NSDate *startDate = [format dateFromString:dbStartDateString];
    NSDate *endDate = [format dateFromString:dbEndDateString];
    [format setDateFormat:@"EEE MMM d"];
    NSString *datePart1 = [format stringFromDate:startDate];
    [format setDateFormat:@"h:mma"];
    NSString *datePart2 = [[format stringFromDate:startDate] lowercaseString];
    NSString *datePart3 = [[format stringFromDate:endDate] lowercaseString];
    return [NSString stringWithFormat:@"%@, %@ to %@",datePart1,datePart2,datePart3];
     */
    
    //Jun 22, 2015 5:00 PM
    NSArray *dateStartParts = [dbStartDateString componentsSeparatedByString:@" "];
    NSArray *dateEndParts = [dbEndDateString componentsSeparatedByString:@" "];
    NSString *result = [NSString stringWithFormat:@"%@ %@ %@%@ to %@%@",dateStartParts[0],dateStartParts[1],dateStartParts[3],[dateStartParts[4] lowercaseString],dateEndParts[3],[dateEndParts[4] lowercaseString]];
    
    return result;
}

//Convert dates from the server to a nicer display string
+(NSString*)toDisplayTime:(NSString*)dbStartDateString
{
    //Jun 22, 2015 5:00 PM
    NSArray *dateParts = [dbStartDateString componentsSeparatedByString:@" "];
    return [NSString stringWithFormat:@"%@%@",dateParts[3],[dateParts[4] lowercaseString]];
}


//Convert dates from the server to a nicer display string
+(NSString*)toTitleDate:(NSString*)dbStartDateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [format setDateFormat:PHDateFormatShort];
    NSDate *startDate = [format dateFromString:dbStartDateString];

    [format setDateFormat:@"EEEE MMMM d"];
    NSString *datePart1 = [format stringFromDate:startDate];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    NSString *datePart2;
    if (minute>0)
    {
        [format setDateFormat:@"h:mma"];
        datePart2 = [format stringFromDate:startDate];
    }
    else
    {
        [format setDateFormat:@"ha"];
        datePart2 = [format stringFromDate:startDate];
    }
    
    return [NSString stringWithFormat:@"%@ %@",datePart1,datePart2];
}

//Convert dates from the server to a nicer display string
+(NSString*)toTitleDateRange:(NSString*)dbStartDateString dbEndDateString:(NSString*)dbEndDateString
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [format setDateFormat:PHDateFormatShort];
    
    //Convert to dates
    NSDate *startDate = [format dateFromString:dbStartDateString];
    NSDate *endDate = [format dateFromString:dbEndDateString];
    
    //Switch to nicer fate format
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //Do start date
    [format setDateFormat:@"EEEE, MMMM d"];
    NSString *startDatePart1 = [format stringFromDate:startDate];
    NSDateComponents *startComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:startDate];
    NSString *startDatePart2;
    if ([startComponents minute]>0)
    {
        [format setDateFormat:@"h:mma"];
        startDatePart2 = [format stringFromDate:startDate];
    }
    else
    {
        [format setDateFormat:@"ha"];
        startDatePart2 = [format stringFromDate:startDate];
    }
    
    //Do end date
    //[format setDateFormat:@"EEEE MMMM d"];
    //NSString *endDatePart1 = [format stringFromDate:endDate];
    NSDateComponents *endComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:endDate];
    NSString *endDatePart2;
    if ([endComponents minute]>0)
    {
        [format setDateFormat:@"h:mma"];
        endDatePart2 = [format stringFromDate:endDate];
    }
    else
    {
        [format setDateFormat:@"ha"];
        endDatePart2 = [format stringFromDate:endDate];
    }
    
    
    return [NSString stringWithFormat:@"%@ At %@ to %@",startDatePart1,startDatePart2,endDatePart2];
}

+(NSString*)formatPhoneNumber:(NSString*)simpleNumber {
    if(simpleNumber.length==0) return @"";
    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]" options:NSRegularExpressionCaseInsensitive error:&error];
    simpleNumber = [regex stringByReplacingMatchesInString:simpleNumber options:0 range:NSMakeRange(0, [simpleNumber length]) withTemplate:@""];
    
    // check if the number is to long
    if(simpleNumber.length>10) {
        // remove last extra chars.
        simpleNumber = [simpleNumber substringToIndex:10];
    }
    
    // 123 456 7890
    // format the number.. if it's less then 7 digits.. then use this regex.
    if(simpleNumber.length<7)
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d+)"
                                                               withString:@"$1-$2"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    
    else   // else do this one..
        simpleNumber = [simpleNumber stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d+)"
                                                               withString:@"$1-$2-$3"
                                                                  options:NSRegularExpressionSearch
                                                                    range:NSMakeRange(0, [simpleNumber length])];
    return simpleNumber;
}

@end


