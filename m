From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: about the CP frequency
Date: Fri, 11 Sep 2009 02:25:05 +0900 (JST)
Message-ID: <20090911.022505.90369779.ryusuke@osrg.net>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, hikaru.zuo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi!
On Thu, 10 Sep 2009 23:56:33 +0900, Hikaru Zuo wrote:
> Hi,
> I'm using nilfs2 on a CentOS(5.2) with nilfs(2.0.14).
> I find a message below in the log
> "nilfsfuse kernel: segctord starting. Construction interval = 5 seconds, *CP
> frequency* < 30 seconds"
> I think that the "interval" means the cleaning_interval,
> but what is the meaning about "*CP frequency*"?

The "interval" means writeback interval of logs, and it's independent
with the cleaning_interval.  Nilfs carries out writeback independently
with presence or absence of GC unless there is no change.

The "CP frequency" means maximum interval of checkpoint creation (CP
denotes checkpoint).

Regards,
Ryusuke Konishi
 
> Please could someone tell me?
> 
> Best regards,
> Hikaru
