From: Byron Guernsey <byron.guernsey-ho6fY9UXzcVBDgjK7y7TUQ@public.gmane.org>
Subject: [SPAM]  Re:  Forcing GC?
Date: Thu, 24 Sep 2009 14:15:43 -0400
Message-ID: <4B835CCB-4157-411C-BE20-EF8CD5322A9E@ikotech.com>
References: <C2EAE475-6100-48BA-81D2-7B56E3D8DD6C@me.com>
	<200909241834.36527.yann.morin.1998@anciens.enib.fr>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: multipart/mixed; boundary="===============1255439200=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200909241834.36527.yann.morin.1998-i2lMhxPFobAPxyCoDXghUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: "Yann E. MORIN" <yann.morin.1998-i2lMhxPFobAPxyCoDXghUg@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org


--===============1255439200==
Content-Type: multipart/signed; boundary=Apple-Mail-22-631037185; protocol="application/pkcs7-signature"; micalg=sha1


--Apple-Mail-22-631037185
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes

I came to a similar conclusion last night after digging deeper into  
the problem.  My capture sets are individual image frames of a video,  
but there is no reason I can't write them contiguously to the SSD and  
extract them to a mechanical hard disk as individual files after  
capture is complete.  I intend to try to store information between  
sessions regarding which portion of the SSD was written to and  
continue the next session after that in a ring-buffer fashion in order  
to extend the SSD life.   What's not clear to me is whether there  
would be an advantage to extending the writes with 0's to block  
boundaries?

Anyway, thanks for the response.  I still wish NILFS was an option  
here since it makes it easier to debug if a filesystem is in place,  
but it sounds like NILFS wasn't design with a temporary high-speed  
spool-type application in mind.

thanks,
Byron

On Sep 24, 2009, at 12:34 PM, Yann E. MORIN wrote:

> Byron,
> All,
>
> On Wednesday 23 September 2009 18:38:00 Byron Guernsey wrote:
>> In my application I have to run many capture sets- as many as 1000,
>> with each being as large as about 28GB.  After a capture completes, I
>> can move it off the spool storage and onto a slower mechanical hard
>> disc.  This is intended to free up space on the SSD for the next
>> capture set.
> [--SNIP--]
>> I know what you're thinking- a RAM drive is really what I need, and I
>> agree.  But a $150 SSD is cheaper than a server-class motherboard and
>> 32GB of ram to use for a ram drive.  So I'm working within a budget
>> and an SSD with NILFS works fine, except for when I need to delete  
>> the
>> files and reclaim space.
>
> I don't think you even need a file system for this...
>
> If your capture set is one big file, then directly use the raw device:
> - add the user running the capture to the group 'disk'
> - have the SSD raw device be group-writeable
> - direct your capture output to the raw device
> - copy the raw device content to long-term storage (eg with dd)
>
> If you use multiple files for your capture:
> - do you know in advance the number of files?
> - is this number small (eg. <16)?
> - do you know in advance the size of each file?
> - if you answered yes to all three questions, then create appropriate
>  partitions on your device, and direct each capture "stream" to one
>  partition, as presented above.
> - if you answered no to any of the above, then you'll indeed need a
>  file system.
>
> Maybe unomuting and re-mounting the partition would be a solution,
> but you'd need root access, or make a small suid program that does
> the mount/umount for you.
>
> Regards,
> Yann E. MORIN.
>
> -- 
> .-----------------.--------------------.------------------.--------------------.
> |  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics'  
> conspiracy: |
> | +0/33 662376056 | Software  Designer | \ / CAMPAIGN     |   
> ___               |
> | --==< ^_^ >==-- `------------.-------:  X  AGAINST      |  \e/   
> There is no  |
> | http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v    
> conspiracy.  |
> `------------------------------^-------^------------------ 
> ^--------------------'
>
>


--Apple-Mail-22-631037185
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGNTCCAu4w
ggJXoAMCAQICEBla31HdKkAr5EP4VOje/MkwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA5MDYxODAzMDMyM1oXDTEwMDYxODAzMDMy
M1owTDEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEpMCcGCSqGSIb3DQEJARYaYnly
b24uZ3Vlcm5zZXlAaWtvdGVjaC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDw
CkhNf4lzUcUMjDNWRG9TIzBMHXcibJ85L1U8cJTVbY1xulT/ek0AwDSjSmQvsWXG3dcrzXVUhMRT
lBpGtpgjQMiV80SB647yQV6E/4KFTEaEgxQnNg8Q62zGyixKz/ywZ+LVhvMHRJ/fkfZA4v3nqBkw
ajK4u9+uv5Azt0ZEF2oEn/WKre51QOc03zV3GjRz3xrvgfgLuFDVW3KqLlfV4oWA5fLN29RsdCVT
85pH3RiVRoa8dvBhUKHWLMs5bHheoAs5sIbZ3dItw6eenYeEm+c3QCxvtN6/rZD1A0qw4Rjg7uHY
sEw61iYg2XhWcCaA5JdAUqog6GPAgRPcjjXnAgMBAAGjNzA1MCUGA1UdEQQeMByBGmJ5cm9uLmd1
ZXJuc2V5QGlrb3RlY2guY29tMAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQEFBQADgYEAiBzyHpWm
PNj+iDsOm4+D364xc2/leC3gTuARnwXXpO3SBRLQgkg4xiFwc+F7wa/fQdcxiPi8NJw7sR7BjORC
gTOTdqXPq7dE9OZigaG3YW2vr6ZjNkx2RUzVebZ3IWAdwIGMsDrAK6nrmx6iBOipTLjp0/PQ7Tpy
TvqgLLt9qfAwggM/MIICqKADAgECAgENMA0GCSqGSIb3DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEV
MBMGA1UECBMMV2VzdGVybiBDYXBlMRIwEAYDVQQHEwlDYXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0
ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9DZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERpdmlzaW9uMSQw
IgYDVQQDExtUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgQ0ExKzApBgkqhkiG9w0BCQEWHHBlcnNv
bmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20wHhcNMDMwNzE3MDAwMDAwWhcNMTMwNzE2MjM1OTU5WjBi
MQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoG
A1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0EwgZ8wDQYJKoZIhvcNAQEB
BQADgY0AMIGJAoGBAMSmPFVzVftOucqZWh5owHUEcJ3f6f+jHuy9zfVb8hp2vX8MOmHyv1HOAdTl
UAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuvPAsH5/EfkTYkKhPPK9Xzgnc9A74r/rsYPge/QIACZNen
prufZdHFKlSFD0gEf6e20TxhBEAeZBlyYLf7AgMBAAGjgZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIB
ADBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsLnRoYXd0ZS5jb20vVGhhd3RlUGVyc29uYWxG
cmVlbWFpbENBLmNybDALBgNVHQ8EBAMCAQYwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVByaXZh
dGVMYWJlbDItMTM4MA0GCSqGSIb3DQEBBQUAA4GBAEiM0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSd
f0whuPg2H6otnzYvwPQcUCCTcDz9reFhYsPZOhl+hLGZGwDFGguCdJ4lUJRix9sncVcljd2pnDmO
jCBPZV+V2vf3h9bGCE6u9uo05RAaWzVNd+NWIXiC3CEZNd4ksdMdRv9dX2VPMYIDEDCCAwwCAQEw
djBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEs
MCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEBla31HdKkAr5EP4
VOje/MkwCQYFKw4DAhoFAKCCAW8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMDkwOTI0MTgxNTQ0WjAjBgkqhkiG9w0BCQQxFgQUhqFCt3CLdqL8RbvOWCLdmEDqvcYw
gYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0
aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5n
IENBAhAZWt9R3SpAK+RD+FTo3vzJMIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAZWt9R3SpAK+RD+FTo3vzJMA0GCSqGSIb3DQEB
AQUABIIBAIvKcbSdHDxx3XNXdt/zPMXJKaXL/bqLSDbclPy5wGPg+1bEtXjDfNs4nsILxX06cP80
uQXMq6kWqZb7nT0eMi+AuQ2PLdGqvCGEzlbP1eswqbLX4o0fBVa5SmNML0ljkf8JEqi79suhvbBT
9m7/QAKMwuK1wjAW94WrkBhk58McrnytZpqIpTtk598HdJlQGZkdCIfmOVoYmja0csz/oHac4jth
iKVW9SnxxduP0MdWLUbivPfqjoyYFlEPL00QEmGvoa7UDsLuIRmxHcCJTmrs8JdTHmhTsYq0Qf0X
pmT1p6gsLvAs2Eprk3t6haU9kLY6wlKH/bH2VEYk051QzaoAAAAAAAA=

--Apple-Mail-22-631037185--

--===============1255439200==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1255439200==--
