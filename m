From: admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org
Subject: Re: cleanerd segfault
Date: Thu,  5 Feb 2009 08:17:52 +0100
Message-ID: <VCNhXQRBhLXj.cwh5ZrWK@mail.prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Language: i-default
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

Yes the git versions from today.I think it must have been some problem introduced the during 2 months as 2 month ago cleanerd run perfectly stable. I have this problem on different nilfs2 filesystems. I am now creating a fresh nilfs2 filesystem to check if I will have the same segfault there and report back. The kernel version is 2.6.28.3 32bit.

Thanks in advance
Bye,
David Arendt

- original message -
Subject:	Re: [NILFS users] cleanerd segfault
From:	Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Date:		05/02/2009 06:54

Hi David,
On Thu, 05 Feb 2009 07:01:25 +0100, David Arendt wrote:
> Hi,
> 
> I am using latest nilfs2 module and nilfs2 utils from today and I am
> getting a segfault when trying to run cleanerd.
>
> nilfs_cleanerd[5784]: segfault at b7f5b000 ip 0804a0db sp bff79720 error
> 4 in nilfs_cleanerd[8048000+5000]
> 
> Could you please look into this ?

Thanks for reports!

You mean git tree versions?
I'm considering to make a minor release in a few days.
If the latest version on git trees seems unstable, I'd like to fix it
before that.

Regards,
Ryusuke
