From: Eric A <eric225125-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: df reports used space gradually growing.
Date: Sun, 26 Jul 2009 08:18:45 -0700 (PDT)
Message-ID: <675178.67834.qm@web58804.mail.re1.yahoo.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1872205091=="
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

--===============1872205091==
Content-Type: multipart/alternative; boundary="0-939234788-1248621525=:67834"

--0-939234788-1248621525=:67834
Content-Type: text/plain; charset=us-ascii

I installed nilfs2 on my 32GB SSD for my rootfs about a week ago and have been very impressed with the improvements in write speed.  However, I just noticed that df reports I am using 25GB when there is only about 13GB of data on the disk.  The 13GB size agrees with du and the size of my daily ext2 backup.  I monitored the situation over night, and the size reported by df appears to be growing by about 1-2GB a day.

Is the size reported by df incorrect?  What will happen when it reports that the entire disk is full?

Eric



      
--0-939234788-1248621525=:67834
Content-Type: text/html; charset=us-ascii

<html><head><style type="text/css"><!-- DIV {margin:0px;} --></style></head><body><div style="font-family:times new roman,new york,times,serif;font-size:12pt"><div>I installed nilfs2 on my 32GB SSD for my rootfs about a week ago and have been very impressed with the improvements in write speed.&nbsp; However, I just noticed that df reports I am using 25GB when there is only about 13GB of data on the disk.&nbsp; The 13GB size agrees with du and the size of my daily ext2 backup.&nbsp; I monitored the situation over night, and the size reported by df appears to be growing by about 1-2GB a day.<br><br>Is the size reported by df incorrect?&nbsp; What will happen when it reports that the entire disk is full?<br><br>Eric<br></div></div><br>



      </body></html>
--0-939234788-1248621525=:67834--


--===============1872205091==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1872205091==--

