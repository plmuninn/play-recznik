package controllers

import play.api._
import play.api.mvc._
import akka.pattern.ask
import shared.{SortPolishList, PolishFirstLetter}
import database.ServiceError
import tables.{SerbianWord, PolishWord}
import play.api.libs.json._
import play.api.libs.functional.syntax._

/**
 * @author loki
 */
object Polish extends MainController {

  implicit val serbianWord: Format[PolishWord] = (
    (JsPath \ "id").formatNullable[Long] and
      (JsPath \ "word").format[String] and
      (JsPath \ "added").format[Boolean] and
      (JsPath \ "active").format[Boolean]
    )(PolishWord.apply, unlift(PolishWord.unapply))

  def find(word: String) = Action.async {
    globalActor.ask(PolishFirstLetter(word)).mapTo[Either[ServiceError, List[PolishWord]]].map({
      case Left(ko) => NotFound
      case Right(ok) => Ok(JsArray(ok.map(word => Json.toJson(word))))
    })
  }

/*  def sort(word: String) = Action.async {
    globalActor.ask(SortPolishList(word)).mapTo[Either[ServiceError, List[PolishWord]]].map({
      case Left(ko) => NotFound
      case Right(ok) => Ok(JsArray(ok.map(word => Json.toJson(word))))
    })
  }*/
}
