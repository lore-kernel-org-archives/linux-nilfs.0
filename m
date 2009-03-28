From: =?ISO-8859-1?Q?Ingo_Gl=F6ckner?= <iglockner-S0/GAf8tV78@public.gmane.org>
Subject: Questions regarding use of nilfs2 on SSDs
Date: Sat, 28 Mar 2009 21:55:54 +0100
Message-ID: <49CE8EDA.8070304@web.de>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
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

Hello,

first of all thank you very much for contributing
this great file system, nilfs2!
I would like to use nilfs2 on an SSD but there
are some open questions, hopefully you can help
me clearing these issues.

- I have read somewhere
> http://www.ocztechnologyforum.com/forum/showpost.php?p=3D361424&postcount=
=3D10

  that using nilfs2 as the rootfs generates enormous I/O traffic
  (up to 45 GB write in 1-2 days!) If this is true, then it will
  eventually translate into reduced lifetime for SSDs.
  Can you confirm that the segment management of nilfs2
  is so write-heavy on the drive?
  If so, are there ways to avoid this?

- The standard segment size of nilfs2 appears to be 8MB.
  This compares to an erase block size of the SSD of
  (say) 512 KB. I wonder if reducing the segment size
  of nilfs to a smaller value (i.e., closer to the
  erase block size of the SSD) will help to
  keep the number of erased blocks/day small
  (this will benefit the lifetime of the drive)
  or if there is no such connection.
  In any case, what is the useful range for segment
  sizes? If I reduce the segment size, will I get
  a performance penalty?

- nilfs_cleanerd.conf specifies the following default values,

# The maximum number of segments to be cleaned at a time.
nsegments_per_clean     2

# Cleaning interval in second.
cleaning_interval       5

Do I interpret this correctly as stating that only 2 segments
(i.e. 16MB) can be cleaned in 5 seconds?
What negative effects will I get if I increase the number
of segments that can be cleaned at a time?

Thanks in advance for your help!
Cheers, Ingo Gl=F6ckner
