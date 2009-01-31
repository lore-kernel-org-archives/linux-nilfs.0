From: David Arendt <admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
Subject: silent random symbolic link corruption
Date: Sat, 31 Jan 2009 21:13:16 +0100
Message-ID: <4984B0DC.6080905@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Hi,

After using nilfs2 for half a year now on data partitions without any
problems, I wanted to try it for the root partition. This way I
discovered a silent random symbolic link corruption problem.

Versions:

latest nilfs2 git module
kernel 2.6.28.2
tar 1.20

Step to reproduce it:

tar -xpf zz1.tar (where zz1.tar is a tar file containing many symbolic
links (in my case a directory containing 2 root filesystems for remote
booting)

On  untar some symbolic links are missing and 0 byte files are existing
instead.

I repeated the test 3 times on a freshly formated nilfs2 partition and
always had other links missing.

I am currently trying to bzip2 the big tar file and untar this one in
order to verify if there are no timing issues and will report back when
this test is finished.

Could you please look into this ?

Thanks in advance
Bye,
David Arendt
