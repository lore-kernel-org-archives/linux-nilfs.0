From: Luis Useche <luis-43oy+cWvsXk3uPMLIKxrzw@public.gmane.org>
Subject: Re: Stressing GC
Date: Fri, 12 Jun 2009 11:02:12 -0400
Message-ID: <20090612150212.GA15879@meg.local>
References: <20090610210859.GA17619@apu.cs.fiu.edu>
	<4A30856F.3000103@0bits.com>
	<20090611153950.GA26921@apu.cs.fiu.edu>
	<20090611152040.GF21314@aardappel.13thmonkey.org>
	<debc30fc0906110951j4d32efb1xd3f73c0cd07a06e1@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <debc30fc0906110951j4d32efb1xd3f73c0cd07a06e1-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On Thu, Jun 11, 2009 at 12:51:17PM -0400, J=E9r=F4me Poulin wrote:
> >
> > On Thu, Jun 11, 2009 at 11:39:50AM -0400, Luis Useche wrote:
> > With the current GC implementation, I am unable to do my experiment. I =
set
> > "protection_period 0" but still have the problem. Besides, this is
> > probably not the right solution either since the GC can do unnecessary =
work
> > that can underestimate the potential of nilfs. I need the first option =
(1)
> > from the first paragraph above.
> >
> =

> For this situation, would it be possible instead, to have to GC collect a=
ll
> the space that can be freed, have the filesystem informed of what blocks =
can
> be freed anytime (like a memory cache which can be flushed anytime), and
> have the FS give the free space information for what it calculated as
> removable? So with this we could have checkpoint for longuer than the
> protection_period and still have the free space available for thing the
> filesystem can just overwrite. I really don't know how it is coded as I'm
> just a user for now, but that would be even greater.

I am in favor of this solution. Ideally, if the user does not want to
protect any data (like in my case), the filesystem should not report space
shortage when plenty of space is available to overwrite. Instead, the GC
must start working right away to make enough room for the incoming writes.

-- =

Luis Useche <luis-43oy+cWvsXk3uPMLIKxrzw@public.gmane.org>
Ph.D. Student
Florida International University
