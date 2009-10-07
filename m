From: Takahiro WATANABE <nemuizo763-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Subject: Cant use nfs with nilfs
Date: Wed, 07 Oct 2009 13:21:39 +0900 (JST)
Message-ID: <20091007.132139.407454645627537773.nemuizo763@yahoo.co.jp>
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

I'm new to use nilfs.
I can't use nfs with nilfs.
I want to know the solution.

When I mount a dir from client, I get like this:

# mount server:/data-dir /mnt
mount: server:/data-dir failed, reason given by server: Permission denied

I also got messages from the nfs server:
Oct  7 13:00:02 server mountd[9904]: authenticated mount request from 192.168.1.99:810 for /data-dir (/data-dir)
Oct  7 13:00:02 server mountd[9904]: can't stat exported dir /data-dir: Permission denied

Below is my settings:

* /etc/exports
/data-dir 192.168.1.0/24(rw,no_root_squash)

* mount
# mount -t nilfs2
/dev/md2 on /data-dir type nilfs2 (rw,gcpid=4858)

* nilfs-utils
nilfs-utils-2.0.14-2 (from fedora11 source)

* Distribution
CentOS5.3 (x86_64)

*kernel 
2.6.31.1 (vanilla kernel)


Cheers,

Takairo.
