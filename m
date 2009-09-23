From: Byron Guernsey <bguernsey-BUHhN+a2lJ4@public.gmane.org>
Subject: Forcing GC?
Date: Wed, 23 Sep 2009 12:38:00 -0400
Message-ID: <C2EAE475-6100-48BA-81D2-7B56E3D8DD6C@me.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0598370752=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org


--===============0598370752==
Content-type: multipart/signed; boundary=Apple-Mail-2-538773583;
 protocol="application/pkcs7-signature"; micalg=sha1


--Apple-Mail-2-538773583
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes

I'm using NILFS2 on an OCZ SSD as a spool for high definition video in  
a scientific application.  I need around 32GB of FAST storage that can  
handle sustained writes of 60MB/s, so NILFS on an SSD works quite  
nicely.

In my application I have to run many capture sets- as many as 1000,  
with each being as large as about 28GB.  After a capture completes, I  
can move it off the spool storage and onto a slower mechanical hard  
disc.  This is intended to free up space on the SSD for the next  
capture set.

But because the NILFS garbage collection is very slow, the space does  
not become available for some time.  And when I tweak the  
cleanerd.conf to run more quickly, it negatively impacts the  
performance during capture.

Is there any way to run nilfs_cleanerd in a manual mode where the  
daemon doesn't execute and you run it to do a full garbage collection  
and exit?  Or maybe some type of control socket or /proc device to  
tell it to run a full GC pass?

I know what you're thinking- a RAM drive is really what I need, and I  
agree.  But a $150 SSD is cheaper than a server-class motherboard and  
32GB of ram to use for a ram drive.  So I'm working within a budget  
and an SSD with NILFS works fine, except for when I need to delete the  
files and reclaim space.

I hate to integrate root privileged operations in this application  
too.  For instance, I could reformat the SSD on every pass, or kill  
cleanerd and start it with aggressive conf parameters when I want to  
run garbage collection and monitor the free space to see when its  
finished- but those aren't ideal.

I like NILFS a lot.  But if I can't get it to free up the space on- 
demand I don't see how it can be a workable solution.  I'll likely  
need to mmap the SSD block device and manage the data myself rather  
than messing with killing/starting the cleanerd on demand.

Byron

  
--Apple-Mail-2-538773583
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGITCCAtow
ggJDoAMCAQICED+NowzPDhIChdCz6lvBo3EwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA5MDYxODAyMjgwOVoXDTEwMDYxODAyMjgw
OVowQjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEfMB0GCSqGSIb3DQEJARYQYmd1
ZXJuc2V5QG1lLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMNCk7PAyZ359i9Y
OTm2Iki5NFPzCOS3de8CTrRgzQq41wbgRF++vJpwA/bXVesaYdwwySxLf2b2nornYjecqSUsgTrB
D1Zt1FwkwKU7taSiq5KAW9ADowl0JaCEMMiX6RrocjHP0nWQqk3S2N3bvBQW0odMZkUh4FAvPYu8
mzGhhCE5uz4pHKykr6asZPLeGF9QnaQJ5B9wR71sZVRPl7e+MlE6s/0rVQ8yA8jxv3iJbD5abOlY
IKSSQQe15ZI//tskKKmbelPK5wPn8BVG5oSWGTDKvoHWzO9ngh3DkF8AsPRcwakBoVlggi09Hd/U
BLpNyAijBFrZaySAMUFi9GkCAwEAAaMtMCswGwYDVR0RBBQwEoEQYmd1ZXJuc2V5QG1lLmNvbTAM
BgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4GBAIs8jZj7TXzKqT5U9O8kwSUWIFCIJRldzxUT
XPoKtN0tGoigxf7nEeyUlB6qHy369Qq/HP+meZ0wftSTi94+ELm08zfRpKga+zH9QXCUQbNHkWlD
RbL2uyn3m4WJvQviEqI0rYaOYfVbQMXNSH84CW6hhFHAShbM5PSOf8lfTbhPMIIDPzCCAqigAwIB
AgIBDTANBgkqhkiG9w0BAQUFADCB0TELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2Fw
ZTESMBAGA1UEBxMJQ2FwZSBUb3duMRowGAYDVQQKExFUaGF3dGUgQ29uc3VsdGluZzEoMCYGA1UE
CxMfQ2VydGlmaWNhdGlvbiBTZXJ2aWNlcyBEaXZpc2lvbjEkMCIGA1UEAxMbVGhhd3RlIFBlcnNv
bmFsIEZyZWVtYWlsIENBMSswKQYJKoZIhvcNAQkBFhxwZXJzb25hbC1mcmVlbWFpbEB0aGF3dGUu
Y29tMB4XDTAzMDcxNzAwMDAwMFoXDTEzMDcxNjIzNTk1OVowYjELMAkGA1UEBhMCWkExJTAjBgNV
BAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25h
bCBGcmVlbWFpbCBJc3N1aW5nIENBMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDEpjxVc1X7
TrnKmVoeaMB1BHCd3+n/ox7svc31W/Iadr1/DDph8r9RzgHU5VAKMNcCY1osiRVwjt3J8CuFWqo/
cVbLrzwLB+fxH5E2JCoTzyvV84J3PQO+K/67GD4Hv0CAAmTXp6a7n2XRxSpUhQ9IBH+nttE8YQRA
HmQZcmC3+wIDAQABo4GUMIGRMBIGA1UdEwEB/wQIMAYBAf8CAQAwQwYDVR0fBDwwOjA4oDagNIYy
aHR0cDovL2NybC50aGF3dGUuY29tL1RoYXd0ZVBlcnNvbmFsRnJlZW1haWxDQS5jcmwwCwYDVR0P
BAQDAgEGMCkGA1UdEQQiMCCkHjAcMRowGAYDVQQDExFQcml2YXRlTGFiZWwyLTEzODANBgkqhkiG
9w0BAQUFAAOBgQBIjNFQg+oLLswNo2asZw9/r6y+whehQ5aUnX9MIbj4Nh+qLZ82L8D0HFAgk3A8
/a3hYWLD2ToZfoSxmRsAxRoLgnSeJVCUYsfbJ3FXJY3dqZw5jowgT2Vfldr394fWxghOrvbqNOUQ
Gls1TXfjViF4gtwhGTXeJLHTHUb/XV9lTzGCAxAwggMMAgEBMHYwYjELMAkGA1UEBhMCWkExJTAj
BgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJz
b25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhA/jaMMzw4SAoXQs+pbwaNxMAkGBSsOAwIaBQCgggFv
MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA5MDkyMzE2MzgwMFow
IwYJKoZIhvcNAQkEMRYEFHimq4xQg+tf/ktLmByKYB5IZEPYMIGFBgkrBgEEAYI3EAQxeDB2MGIx
CzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYD
VQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQP42jDM8OEgKF0LPqW8Gj
cTCBhwYLKoZIhvcNAQkQAgsxeKB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29u
c3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNz
dWluZyBDQQIQP42jDM8OEgKF0LPqW8GjcTANBgkqhkiG9w0BAQEFAASCAQBJaa8Ugt1qnmeVG47k
yqU6XG83r4Xg685sJBQwTJD4/iBfUbp45vccxeg8Tevqdz1p5o4Oann1HTQMbmqvFYwkCdi4Kaly
vW/btfYGMz7zZI6sb9smcsJmzHya08nKPjyydzl+LwUOeDHczjj7wuWcflcajn8i1OPkT+l7XhIt
Kl9CuohkLYc70arPu3RPV9HRXgaq6SZPNA3kWhvyMnuHFrUqkTVMqc2/BGuahl2A1b/DpYRlj7Qh
0n1AI3i86xNRy1RQQVgR8TF6q/LlAvQhIW2qryG3J51i3HAeIfJR28odpd8v3F8zWmKGL/t4IjcX
xhEc8fnko6b/eAXO0PSaAAAAAAAA

--Apple-Mail-2-538773583--

--===============0598370752==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0598370752==--
