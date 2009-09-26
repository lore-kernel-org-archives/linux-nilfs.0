From: Jeff Layton <laytonjb-fOdFMYwuEsI@public.gmane.org>
Subject: Re: IOzone testing
Date: Sat, 26 Sep 2009 09:14:59 -0400
Message-ID: <4ABE13D3.2080809@att.net>
References: <4ABE0553.3090502@att.net>	<debc30fc0909260554s21969638h280d9e6f89b7596e@mail.gmail.com>
	<4ABE0AD7.7000904@att.net>
	<debc30fc0909260627n12616bddif87b25f0ae64b6f5@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <debc30fc0909260627n12616bddif87b25f0ae64b6f5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

J=E9r=F4me Poulin wrote:
> On Sat, Sep 26, 2009 at 8:13 AM, Jeff Layton <laytonjb-fOdFMYwuEsI@public.gmane.org> wrote:
>   =

>> It will only stop the clean up of checkpoints outside of policy - correc=
t?
>> So it won't stop them from being created but it will stop the cleaning
>> process.
>>
>>     =

> It will completely stop cleaning checkpoints, which is what is
> consuming drive I/O. Checkpoints in themselve don't use much
> ressources, cleaning them however does.
>   =


Got it - thanks.

At the same time, I also hit an out of space message. Why would I
get this message? If the checkpoints are just creating a small maker
then it shouldn't take much space. Unless of course, a huge number
of checkpoints are created.

Thanks!
