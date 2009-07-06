From: James Erickson <psykojime-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Subject: Re: can't start nilfs_cleanerd on root fs
Date: Sun, 5 Jul 2009 21:51:04 -0500
Message-ID: <20090706025104.GA6163@odysseus.gateway.2wire.net>
References: <mailman.1.1246762801.19752.users@nilfs.org>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <mailman.1.1246762801.19752.users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
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

i have nilfs2 as my root partition also. the only thing that works for
me is to call nilfs_cleanerd explicitly as root with no device. so as
root i just call "/sbin/nilfs_cleanerd" and it starts on the root
partititon. i don't know why this is but it is the only thing that works
on my gentoo amd64 system. i would like for it to start at boot but it
does not. maybe this will change in the future. good luck.
