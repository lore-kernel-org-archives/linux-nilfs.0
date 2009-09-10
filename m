From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: about the CP frequency
Date: Thu, 10 Sep 2009 13:06:00 -0400
Message-ID: <debc30fc0909101006x7942dc53hf1a4d10f147f8d42@mail.gmail.com>
References: <bf1045310909100756y4442607fg66481eab7be84b81@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <bf1045310909100756y4442607fg66481eab7be84b81-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: hikaru.zuo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

CP frequency means CheckPoint frequency, which means it will create a
checkpoint at least every 30 seconds, so if you create a document at
11:30:10 and delete it at 11:30:41 you can be sure to recover it by
converting the created checkpoint in snapshot later if it does not
exceed the protection period specified in seconds in
/etc/nilfs_cleanerd.conf

On Thu, Sep 10, 2009 at 10:56 AM, Hikaru Zuo <hikaru.zuo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi,
> I'm using nilfs2 on a CentOS(5.2) with nilfs(2.0.14).
> I find a message below in the log
> "nilfsfuse kernel: segctord starting. Construction interval = 5 seconds, CP
> frequency < 30 seconds"
> I think that the "interval" means the cleaning_interval,
> but what is the meaning about "CP frequency"?
>
> Please could someone tell me?
>
> Best regards,
> Hikaru
>
> _______________________________________________
> users mailing list
> users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
> https://www.nilfs.org/mailman/listinfo/users
>
>
