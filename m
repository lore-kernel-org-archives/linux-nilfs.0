From: Takahiro WATANABE <nemuizo763-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: Re: Cant use nfs with nilfs
Date: Wed, 07 Oct 2009 18:43:06 +0900 (JST)
Message-ID: <20091007.184306.759900912694740657.nemuizo763@yahoo.co.jp>
References: <20091007.132139.407454645627537773.nemuizo763@yahoo.co.jp>
	<874oqbsiu8.wl%jir@sekiba.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <874oqbsiu8.wl%jir-27yqGEOhnJbQT0dZR+AlfA@public.gmane.org>
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

: It looks like somewrong with NFS configuration to me.
: What if export the directory without mounting nilfs partition?

I got messages below when exporting a partition with ext3.
Oct  7 18:35:25 nfs-host4 mountd[10254]: authenticated mount request from 192.168.1.99:802 for /data-ext3 (/data-ext3)

Anyway, I found the tempolary solution.
Disabling the SElinux on nfs server was fixed for me :-(

I guess a SElinux policy has to be written to access the server.

Cheers,

Takahiro.



From: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
Subject: Re: [NILFS users] Cant use nfs with nilfs
Date: Wed, 07 Oct 2009 17:34:39 +0900

: Hi, 
: 
: 
: > I'm new to use nilfs.
: > I can't use nfs with nilfs.
: > I want to know the solution.
: > 
: > When I mount a dir from client, I get like this:
: > 
: > # mount server:/data-dir /mnt
: > mount: server:/data-dir failed, reason given by server: Permission denied
: > 
: > I also got messages from the nfs server:
: > Oct  7 13:00:02 server mountd[9904]: authenticated mount request from 192.168.1.99:810 for /data-dir (/data-dir)
: > Oct  7 13:00:02 server mountd[9904]: can't stat exported dir /data-dir: Permission denied
: 
: It looks like somewrong with NFS configuration to me.
: What if export the directory without mounting nilfs partition?
: 
: > Below is my settings:
: > 
: > * /etc/exports
: > /data-dir 192.168.1.0/24(rw,no_root_squash)
: > 
: > * mount
: > # mount -t nilfs2
: > /dev/md2 on /data-dir type nilfs2 (rw,gcpid=4858)
: > 
: > * nilfs-utils
: > nilfs-utils-2.0.14-2 (from fedora11 source)
: > 
: > * Distribution
: > CentOS5.3 (x86_64)
: > 
: > *kernel 
: > 2.6.31.1 (vanilla kernel)
: > 
: > 
: > Cheers,
: > 
: > Takairo.
: > 
: > 
: > 
: > 
: > _______________________________________________
: > users mailing list
: > users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
: > https://www.nilfs.org/mailman/listinfo/users
: > 
: > 
: 
: regards,
: -- 
: Jiro SEKIBA <jir-hfpbi5WX9J54Eiagz67IpQ@public.gmane.org>
: _______________________________________________
: users mailing list
: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
: https://www.nilfs.org/mailman/listinfo/users
