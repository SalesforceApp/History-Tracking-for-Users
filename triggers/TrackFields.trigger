trigger TrackFields on User (after update)
{
    List<History_Tracking_User__c> trackFields = new List<History_Tracking_User__c>();
    for(User user : Trigger.new)
    {
        User oldUser = Trigger.oldMap.get(user.Id);
        
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get('User');
        Map<String, Schema.SObjectField> fieldMap = targetType.getDescribe().fields.getMap();
        for(String field : fieldMap.keySet())
        {
            Schema.DescribeFieldResult fieldProxy = fieldMap.get(field).getDescribe();
            String oldValue = '';
            String newValue = '';
            if(String.valueOf(fieldProxy.getSoapType()) == 'Boolean')
            {
                oldValue = tranferBooleantoStr((Boolean)oldUser.get(fieldProxy.getName()));
                newValue = tranferBooleantoStr((Boolean)user.get(fieldProxy.getName()));
            }
            else if(String.valueOf(fieldProxy.getSoapType()) == 'DateTime')
            {
                oldValue = tranferDateTimetoStr((DateTime)oldUser.get(fieldProxy.getName()));
                newValue = tranferDateTimetoStr((DateTime)user.get(fieldProxy.getName()));
            }
            else if(String.valueOf(fieldProxy.getSoapType()) == 'Date')
            {
                oldValue = tranferDatetoStr((Date)oldUser.get(fieldProxy.getName()));
                newValue = tranferDatetoStr((Date)user.get(fieldProxy.getName()));
            }
            else if(String.valueOf(fieldProxy.getSoapType()) == 'Integer')
            {
                oldValue = tranferIntegertoStr((Integer)oldUser.get(fieldProxy.getName()));
                newValue = tranferIntegertoStr((Integer)user.get(fieldProxy.getName()));
            }
            else if(String.valueOf(fieldProxy.getSoapType()) != 'Address')
            {
                oldValue = (String)oldUser.get(fieldProxy.getName());
                newValue = (String)user.get(fieldProxy.getName());
            }
            if(oldValue != newValue && fieldProxy.getName() != 'LastModifiedDate' && fieldProxy.getName() != 'SystemModstamp' && fieldProxy.getName() != 'Data.comMonthlyAdditionLimit')
            {
                History_Tracking_User__c trackUser = new History_Tracking_User__c(User__c = user.Id, Name = fieldProxy.getLabel(), Old_Value__c = oldValue, New_Value__c = newValue, Created_DateTime__c = System.Now());
                trackFields.add(trackUser);
            }
        }
    }
    
    if(trackFields.size() > 0)
    {
        insert trackFields;
    }
    
    private String tranferBooleantoStr(Boolean bool)
    {
        if(bool)
        {
            return 'true';
        }
        return 'false';
    }
    
    private String tranferDateTimetoStr(DateTime dateTimeVal)
    {
        if(dateTimeVal == null)
        {
            return '';
        }
        return dateTimeVal.format();
    }
    
    private String tranferDatetoStr(Date dateVal)
    {
        if(dateVal == null)
        {
            return '';
        }
        return dateVal.Month() + '/' + dateVal.Day() + '/' + dateVal.Year();
    }
    
    private String tranferIntegertoStr(Integer intVal)
    {
        if(intVal == null)
        {
            return '';
        }
        return String.valueOf(intVal);
    }
}