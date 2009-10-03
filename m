From: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Subject: Re: NILFS errors.
Date: Sat, 03 Oct 2009 20:13:30 +0900 (JST)
Message-ID: <20091003.201330.10734740.ryusuke@osrg.net>
References: <200910021857.28569.yuri@itinteg.net>
	<20091003.131155.120264262.ryusuke@osrg.net>
	<200910031221.34016.yuri@itinteg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <200910031221.34016.yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org>
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
To: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org, yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org

On Sat, 3 Oct 2009 12:21:33 +0200, Yuri Chislov <yuri-EJC0RcYdacHR7s880joybQ@public.gmane.org> wrote:
> Thank you for patch. I have install it just now and reformat /dev/md4.
> Is it planned some fsck tool?

Unfortunately No (at least for the time being).

> I can help with tests if necessary.
> Yuri. 

Yes, I would appreciate if you could help testing.

Before that, please let me know whether the corruption is reproducible
on a new file system after applying the "fix missing zero-fill
initialization of btree node cache" patch.

It is necessary to narrow down the cause of your problem.
 
Thank you,
Ryusuke Konishi
