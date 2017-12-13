% Class for sending emails
%{
This does not work with UNC and google (authentication issues)
%}
classdef Email < handle
   
properties
   % From address
   address = 'lutz@lhendricks.org'
   smtpServer = 'smtp.zoho.com';
   smtpPassword = 'dsx25pq64';
   
   % Test mode: don't send; just show on screen what would be sent
   testMode  logical = false
end

properties (Constant)
   % Carriage return
   cReturn = char(10);
end

   
methods
   %% Constructor
   function emS = Email(addressIn, smtpServerIn, smtpPassIn)
      if ~isempty(smtpServerIn)
         emS.smtpServer = smtpServerIn;
      end
      if ~isempty(smtpPassIn)
         emS.smtpPassword = smtpPassIn;
      end
      if ~isempty(addressIn)
         emS.address = addressIn;
      end
      emS.initialize;
   end
   

   %% Initializer
   % Must be run once per session
   function initialize(emS)
      setpref('Internet','E_mail',emS.address);
      setpref('Internet','SMTP_Server',emS.smtpServer);
      setpref('Internet','SMTP_Username',emS.address);
      setpref('Internet','SMTP_Password',emS.smtpPassword);

      props = java.lang.System.getProperties;
      props.setProperty('mail.smtp.auth','true');
      props.setProperty('mail.smtp.socketFactory.class', ...
                        'javax.net.ssl.SSLSocketFactory');
      props.setProperty('mail.smtp.socketFactory.port','465');   
      % props.setProperty('mail.smtp.socketFactory.port','587');   
      % props.setProperty('mail.smtp.port','465');
   end
   
   
   %%  Send an email
   function send(emS, toAddress, subjectStr, messageV, doConfirm)
      % Make message into a single string
      if ischar(messageV)
         messageStr = [messageV, emS.cReturn];
      else
         messageStr = '';
         for i1 = 1 : length(messageV)
            messageStr = [messageStr, messageV{i1}, emS.cReturn];
         end
      end
      
      if doConfirm
         fprintf('\n%s      %s\n', toAddress, subjectStr);
         fprintf('%s \n\n', messageStr);
         answer1 = input('Send e-mail?  ', 's');
         if ~strcmp(answer1, 'yes')
            return;
         end
      end
      
      if emS.testMode
         fprintf('\n%s      %s\n', toAddress, subjectStr);
         fprintf('%s \n\n', messageStr);
      else
         sendmail(toAddress, subjectStr, messageStr);
      end
   end
end
   
end
