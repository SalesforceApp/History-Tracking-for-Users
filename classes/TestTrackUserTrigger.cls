@isTest
public class TestTrackUserTrigger
{
    @isTest
    public static void testUpdateUser()
    {
        User user = [select Id, Name, Email, Phone from User where Id = :UserInfo.getUserId()];
        user.Email = 'test@acme.com';
        update user;
        System.assert(user.Email == 'test@acme.com');
    }
}