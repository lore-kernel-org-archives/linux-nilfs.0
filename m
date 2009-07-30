From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: remove chown from makefiles too?
Date: Thu, 30 Jul 2009 11:25:52 -0500
Message-ID: <4A71C990.3060804@redhat.com>
References: <4A71B53D.7070205@redhat.com>
	<20090731.005317.12928769.ryusuke@osrg.net>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <20090731.005317.12928769.ryusuke-sG5X7nlA6pw@public.gmane.org>
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
To: Ryusuke Konishi <ryusuke-sG5X7nlA6pw@public.gmane.org>
Cc: users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org

Ryusuke Konishi wrote:
> Hi,
> On Thu, 30 Jul 2009 09:59:09 -0500, Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

...

>> I don't think there's any reason for the chown; can this just be removed?
> 
> Well, I see.
> 
> I will once remove the chown and normalize it unless the removal makes
> inconvenience to someone.
> 
> Thank you for the comment.
> 
> Ryusuke Konishi

thanks - on a similar topic, the Makefile in lib/ wants to run ldconfig,
I think it's a similar problem for non-root builds.

For now I've just worked around these problems in the Fedora build.

Thanks,
-Eric
