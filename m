From: "Kevin Burton" <burton-G7Y02uMBy1dWk0Htik3J/w@public.gmane.org>
Subject: Using nilfs to increase performance of NAND/SSD flash
	devices.
Date: Fri, 1 Feb 2008 12:31:47 -0800
Message-ID: <30c6373b0802011231t75a8a00djab3c82b4de3fa928@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1810606546=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=gamma;
	h=domainkey-signature:received:received:message-id:date:from:sender:to:subject:mime-version:content-type:x-google-sender-auth;
	bh=jwzFX6rqBo97XGahXtXUdReINw+03dLb9GUVe/FwcB8=;
	b=fi6TmaAlP8WQJjm4raljwsGolwMmTiBtofJGtAPBioxIuFly+8lJ7DM5lTKrgLDetAEO9ihTYwaJH+/xgvttORKpPoPbMr1B3KARmr3nVwymL45t6SxYx/OdqAABpYfxVVaWIAeSm42yF8NbpBcDxMtq6vEH5QeyjJLawpvUpR4=
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

--===============1810606546==
Content-Type: multipart/alternative; 
	boundary="----=_Part_2020_8159454.1201897907617"

------=_Part_2020_8159454.1201897907617
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hey guys.

I'm playing with nilfs2 on an Mtron SSD 32G NAND Flash SATA drive.

NAND is GREAT for random reads but horrible for random writes.

A log filesystem fixes this problem because when the disk does random writes
it
will just read the block from the previous erase block and wrote a new block
with the data to the end of the drive, thereby simulating sequential writes.

I tested this theory by comparing nilfs2 to XFS on the mtron with a
sysbenchm
random write to test.  Sure enough nilfs2 beat out XFS by 8.5x and wrote at
about 50MB/s which is amazingly impressive.

The problem is that with I used the sysbench OLTP benchmark it was only
about
10% faster than an HDD running XFS.

Not too impressive.

The OLTP benchmark simulates a MySQL box doing lots of random DELETE,
UPDATE,
and INSERT commands so you end up seeing lots or random writes to the disk.

In theory nilfs2 should be able to boost hte performance here but I didn't
see
this in practice.

I think what might be happening is that the consistent snapshot support
might be
slowing down performance by keeping older blogs on disk and doing too many
sequential writes thereby seeing slower performance.

Is it possible to disable checkpointing to test my theory?  I'm just about
to
dive into the source to test this out but I wanted to post here first to get
your thoughts.

Onward!

Kevin

-- 
Founder/CEO Tailrank.com
Location: San Francisco, CA
AIM/YIM: sfburtonator
Skype: burtonator
Work: http://spinn3r.com and http://tailrank.com
Blog: http://feedblog.org
Cell: 415-637-8078
Fax: 1-415-358-419 PIN: 0092

------=_Part_2020_8159454.1201897907617
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<br>Hey guys.<br><br>I&#39;m playing with nilfs2 on an Mtron SSD 32G NAND Flash SATA drive.<br><br>NAND is GREAT for random reads but horrible for random writes.<br><br>A log filesystem fixes this problem because when the disk does random writes it<br>
will just read the block from the previous erase block and wrote a new block<br>with the data to the end of the drive, thereby simulating sequential writes.<br><br>I tested this theory by comparing nilfs2 to XFS on the mtron with a sysbenchm<br>
random write to test.&nbsp; Sure enough nilfs2 beat out XFS by 8.5x and wrote at<br>about 50MB/s which is amazingly impressive.<br><br>The problem is that with I used the sysbench OLTP benchmark it was only about<br>10% faster than an HDD running XFS.<br>
<br>Not too impressive.<br><br>The OLTP benchmark simulates a MySQL box doing lots of random DELETE, UPDATE,<br>and INSERT commands so you end up seeing lots or random writes to the disk.<br><br>In theory nilfs2 should be able to boost hte performance here but I didn&#39;t see<br>
this in practice.<br><br>I think what might be happening is that the consistent snapshot support might be<br>slowing down performance by keeping older blogs on disk and doing too many<br>sequential writes thereby seeing slower performance.<br>
<br>Is it possible to disable checkpointing to test my theory?&nbsp; I&#39;m just about to<br>dive into the source to test this out but I wanted to post here first to get<br>your thoughts.<br><br>Onward!<br><br>Kevin<br><br>-- <br>
Founder/CEO <a href="http://Tailrank.com">Tailrank.com</a><br>Location: San Francisco, CA<br>AIM/YIM: sfburtonator<br>Skype: burtonator<br>Work: <a href="http://spinn3r.com">http://spinn3r.com</a> and <a href="http://tailrank.com">http://tailrank.com</a><br>
Blog: <a href="http://feedblog.org">http://feedblog.org</a><br>Cell: 415-637-8078<br>Fax: 1-415-358-419 PIN: 0092<br>

------=_Part_2020_8159454.1201897907617--

--===============1810606546==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1810606546==--
