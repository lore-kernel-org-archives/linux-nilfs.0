From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Creating NILFS2 on Fedora 11
Date: Tue, 08 Sep 2009 23:45:18 -0500
Message-ID: <4AA732DE.9060506@redhat.com>
References: <2324ff2b0909062047scb58709h3255655c068661be@mail.gmail.com>
	<debc30fc0909062113h29610480wb4ea49c59eecdb39@mail.gmail.com>
	<4AA6832B.7070905@redhat.com>
	<2324ff2b0909082139x660cfb7dj3b6cd4f37f6bbc5f@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <2324ff2b0909082139x660cfb7dj3b6cd4f37f6bbc5f-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

Prasenjit Giri wrote:
> Hello Jerome and Eric,
> Thanks for the info. See I was trying to do the b- tree based directory 
> management and if fedora is still in the dumps supporting NILFS2, which 
> distro do you think I must use? or rather which distro's have you all 
> been using...
> 

nilfs-utils are in fedora 11 and rawhide, and the rawhide kernel has 
nilfs2 as well, so it's as good as any distro for nilfs2 support, I 
think.  No distro will have full integration with things like blkid, 
yet, but it's certainly useable (just mount -t nilfs2 ....)

I'm keeping nilfs-utils up to date in rawhide so it should be useful if 
you want to give it a shot.

-Eric
