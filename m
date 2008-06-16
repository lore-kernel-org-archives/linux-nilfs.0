From: "Christopher Nelson" <nadiasvertex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: error with ubuntu hardy and nilfs2 on mount
Date: Mon, 16 Jun 2008 13:58:35 -0400
Message-ID: <c38b163f0806161058t662d42ffxe590fba6ec2d3075@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0693417303=="
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

--===============0693417303==
Content-Type: multipart/alternative; 
	boundary="----=_Part_5537_7932819.1213639115027"

------=_Part_5537_7932819.1213639115027
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

root@kraken:/# mkfs -t nilfs2 /dev/sdb2
mkfs.nilfs2 ver 2.0
Start writing file system initial data to the device
       Blocksize:4096  Device:/dev/sdb2  Device Size:491912838144
File system initialization succeeded !!
root@kraken:/# mount.nilfs2 -vv /dev/sdb2 /work
mount.nilfs2: started nilfs_cleanerd
Segmentation fault

This with the .18 kernel and the latest modules and tools from nilfs. Also,
this is an AMD64 machine.

-={C}=-

------=_Part_5537_7932819.1213639115027
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

root@kraken:/# mkfs -t nilfs2 /dev/sdb2<br>mkfs.nilfs2 ver 2.0<br>Start writing file system initial data to the device<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Blocksize:4096&nbsp; Device:/dev/sdb2&nbsp; Device Size:491912838144<br>File system initialization succeeded !! <br>
root@kraken:/# mount.nilfs2 -vv /dev/sdb2 /work<br>mount.nilfs2: started nilfs_cleanerd<br>Segmentation fault<br><br>This with the .18 kernel and the latest modules and tools from nilfs. Also, this is an AMD64 machine.<br>
<br>-={C}=-<br><br><br>

------=_Part_5537_7932819.1213639115027--

--===============0693417303==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0693417303==--
