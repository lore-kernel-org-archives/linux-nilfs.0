From: Saloustros Georgios <gesalous-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Low nilfs Disk utilization
Date: Mon, 21 Sep 2009 16:54:50 +0300
Message-ID: <1ee4eebe0909210654y3abe8bfaw14209035b0ebe625@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0784459545=="
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

--===============0784459545==
Content-Type: multipart/alternative; boundary=0015174bf2aa530c95047416d392

--0015174bf2aa530c95047416d392
Content-Type: text/plain; charset=ISO-8859-1

Hello all.
For my application, which is written in Java, I need a file system, on top
of Linux software raid-0 (md), that guarantees contiguous allocation of
blocks for a large number of small files, in order to increase write
throughput.
For this reason, in the last days I have been experimenting with nilfs2,
which seems the best solution for my application needs.
I am running Red Hat Enterprise Linux 5 (rhel5), kernel-version 2.6.18-prep,
nilfs-2.0.16 and nilfs-utils-2.0.14.
Software Raid-0 consists of two Maxtor 500 GB with chuck size 64K.
System's Memory is 2GB.
For testing reasons I wrote a simple disk benchmark in java, where 8 threads
append 256KB dummy blocks from memory to a log-file. Total IO is 8 GB.
With ext3 mounted with data=writeback mode, each drive alone gives 63MB/sec
and as a raid-0 array a total of 90 MB/sec.

Nilfs has worst performance for the same scenario. 1 Disk alone gives
34MB/sec and two disks on raid-0 setup 39 MB/sec.

Using iostat I can see that disks are 50% utilized with nilfs, whereas with
ext3 are 100% utilized. Why is this happening? Is my configuration wrong?

-- 
Thanks,
G.S.

--0015174bf2aa530c95047416d392
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello all.<br>For my application, which is written in Java, I need a file s=
ystem, on top of Linux software raid-0 (md), that guarantees contiguous all=
ocation of blocks for a large number of small files, in order to increase w=
rite throughput.<br clear=3D"all">
For this reason, in the last days I have been experimenting with nilfs2, wh=
ich seems the best solution for my application needs.<br>I am running Red H=
at Enterprise Linux 5 (rhel5), kernel-version 2.6.18-prep, nilfs-2.0.16 and=
 nilfs-utils-2.0.14.<br>
Software Raid-0 consists of two Maxtor 500 GB with chuck size 64K.<br>Syste=
m&#39;s Memory is 2GB.<br>For testing reasons I wrote a simple disk benchma=
rk in java, where 8 threads append 256KB dummy blocks from memory to a log-=
file. Total IO is 8 GB.<br>
With ext3 mounted with data=3Dwriteback mode, each drive alone gives 63MB/s=
ec and as a raid-0 array a total of 90 MB/sec.<br><br>Nilfs has worst perfo=
rmance for the same scenario. 1 Disk alone gives 34MB/sec and two disks on =
raid-0 setup 39 MB/sec. <br>
<br>Using iostat I can see that disks are 50% utilized with nilfs, whereas =
with ext3 are 100% utilized. Why is this happening? Is my configuration wro=
ng?=A0 <br><br>-- <br>Thanks,<br>G.S.<br>

--0015174bf2aa530c95047416d392--

--===============0784459545==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============0784459545==--
