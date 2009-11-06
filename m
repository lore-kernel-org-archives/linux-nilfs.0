From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [SPAM] Re: urgent help need! disk partition info
	lost
Date: Fri, 6 Nov 2009 14:24:08 -0500
Message-ID: <debc30fc0911061124r1a13335v61c8df3dffa70c51@mail.gmail.com>
References: <856033f20911021106u771f823dkb48395958ad83a37@mail.gmail.com> 
	<ee5afd760911041046s70ada5d6w686ce83814b3e9e6@mail.gmail.com> 
	<856033f20911041131n54c420fuf16b10fefb343188@mail.gmail.com> 
	<ee5afd760911041326g77cab1d9r90f55657dc11a789@mail.gmail.com> 
	<856033f20911041719w12410864hdbdb8d5e6aed2070@mail.gmail.com> 
	<856033f20911041957n7c88e5afvb60b6de9ee42bce7@mail.gmail.com> 
	<ee5afd760911050718t4eca6855kdf70fcc7f2014bf8@mail.gmail.com> 
	<856033f20911051002x79461f91o60e07f651a24f7c4@mail.gmail.com> 
	<ee5afd760911051211n788e4f36g7f60d06e691817d8@mail.gmail.com> 
	<856033f20911060943i35d9cae4rcaf6a6dd12a6d845@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <856033f20911060943i35d9cae4rcaf6a6dd12a6d845-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On Fri, Nov 6, 2009 at 12:43 PM, Paul L <ninegua-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Ok, based on the info so far, I've successfully recovered my files!
>
...
>
> 6. Now it seemed no way to proceed, and I decided to try my luck by
> modifying nilfs_search_super_root(...) function to do a partial check
> instead of a full check (by changing the flag from 1 to 0). Compiled,
> installed, and rebooted.
>
This is where I'd like to add, the filesystem should always allow to
mount read-only whatever there is corruption or not, if there is bad
bad trouble it should mount read-only and ignore the cleanerd, isn't
that right?

> It then all worked out from there. I immediately plugged in a USB
> drive, and copied all my files to the backup. Only one file seemed to
> have been damaged during the incident. I didn't bother to check if all
> the prevoius checkpoint on the nilfs2 partition worked and just went
> ahead and re-partitioned and re-formatted the SD card.
>
> I must thank Jan de Kruyf for the tremendeous help! Thank you all very much!
>
> Now I'm just going to celebrate the magical recovery from the loss of
> months' hard work!
>
>
I guess you're going to make a backup every week from now :)
