From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: cleanerd segfault
Date: Thu, 05 Feb 2009 15:54:40 +0900 (JST)
Message-ID: <20090205.155440.55718544.ryusuke@osrg.net>
References: <498A80B5.9080007@prnet.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <498A80B5.9080007-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, admin-/LHdS3kC8BfYtjvyW6yDsg@public.gmane.org

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
