From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: Request for a project idea
Date: Sat, 08 Aug 2009 01:56:52 +0900 (JST)
Message-ID: <20090808.015652.110306442.ryusuke@osrg.net>
References: <788403f80908060554r180bf59djabdb9ee7bea22ce2@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <788403f80908060554r180bf59djabdb9ee7bea22ce2-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, sparx2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hi,
On Thu, 6 Aug 2009 18:24:24 +0530, Aruna Medhekar wrote:
> Sir,
>
> We are a group of 4 under graduate students who wish to complete a
> project in nilfs.We have gone through your to-do lists but we did
> not find anything that we could do in a whole year.Can you please
> suggest something that might be possible for us to implement?

Well, do you like userland task or kernel work ?

If you don't mind it, I expect your help on enriching userland
applications.  Nilfs only has a minimum of CUI utilities, and no GUI
tool exists for nilfs at present.

For example, an X-based GUI program which draws disk block allocation
state of nilfs, would be helpful and fun. (I think, application or
kernel code needing disk write is hard, but read is rather easy if you
nicely port b-tree lookup routines to userland)

Does it match your direction?

Cheers,
Ryusuke Konishi
