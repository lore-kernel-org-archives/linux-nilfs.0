From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Creating NILFS2 on Fedora 11
Date: Mon, 7 Sep 2009 00:13:20 -0400
Message-ID: <debc30fc0909062113h29610480wb4ea49c59eecdb39@mail.gmail.com>
References: <2324ff2b0909062047scb58709h3255655c068661be@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <2324ff2b0909062047scb58709h3255655c068661be-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

fdisk shows the partition type which should be 83 (Linux), not what FS
it contains, most likely no utilities (like blkid) support detecting
NilFS2 yet. Be sure to keep in mind the experimental nature of NilFS2
before putting all your data on it.

On Sun, Sep 6, 2009 at 11:47 PM, Prasenjit
Giri<tangyorangesour-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> I tried to format a partition, though it formatted me the drive with this,
> but upon fdisk -l it didn't show the new type.
>
> --
> Prasenjit Giri
>
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>
>
